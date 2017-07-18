class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show]
  respond_to :html
  layout 'window'
  

  def index
    @contracts = Contract.list(current_user.unit_id, session[:customer_id]).paginate(:page => params[:page], :per_page => 20)
  end


  def show
    @contract_tickets = ContractTicket.where('unit_id = ? AND contract_id = ?', current_user.unit_id, params[:id])
    @bank_slips = BankSlip.list(current_user.unit_id, session[:customer_id]).where("contract_id = ?", params[:id]).order('due_at')
    respond_with @contract
  end


  def create_contract
    cod = params[:cod]

    debtor = Debtor.find(cod)
    customer = Customer.find session[:customer_id]
    unit = Unit.find(current_user.unit_id)
    tickets = Ticket.list(current_user.unit_id, session[:customer_id], params[:cod]).open.where('charge = ?', true)

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = current_user.unit_id
      @contract.customer_id = session[:customer_id]
      @contract.debtor_id = cod
      @contract.user_id = current_user.id
      @contract.amount_principal = session[:total_ticket_cobrado].to_f.round(2)
      @contract.ticket_quantity = session[:bank_slips].count
      @contract.status = :open
      @contract.save!

      session[:bank_slips].each  do |tic|
        bank_slip = BankSlip.new
        bank_slip.unit_id = current_user.unit_id
        bank_slip.customer_id = @contract.customer_id
        bank_slip.debtor_id = @contract.debtor_id
        bank_slip.bank_account_id = customer.bank_account_id
        bank_slip.contract_id = @contract.id

        bank_slip.amount_principal = tic['amount_principal'].to_f
        bank_slip.due_at = tic['due_at']

        bank_slip.customer_name = customer[:name]
        bank_slip.customer_document = customer[:cnpj].present? ? customer[:cnpj] : customer[:cpf]
        bank_slip.status = :generating

        bank_slip.save!
      end

      tickets.each do  |ticket|
        ticket.contract_id = @contract.id
        ticket.status = :contract
        ticket.save!

        contract_ticket = ContractTicket.new
        contract_ticket.unit_id = current_user.unit_id
        contract_ticket.contract_id = @contract.id
        contract_ticket.ticket_id = ticket.id
        contract_ticket.customer_id = customer.id
        contract_ticket.debtor_id = debtor.id
        contract_ticket.amount_principal = ticket.amount_principal
        contract_ticket.amount_monetary_correction = Ticket.calc_amount_monetary_correction(ticket, nil, nil, false)
        contract_ticket.amount_interest = Ticket.calc_amount_interest(ticket, nil, nil, true, false)
        contract_ticket.amount_fine = Ticket.calc_amount_fine(ticket, nil, nil, true, true, false)
        contract_ticket.amount_tax = Ticket.calc_amount_tax(ticket, nil, nil, false, true, true, true)
        contract_ticket.save!

      end
    end

    respond_with @contract, notice: 'Contrato gerado com sucesso.'
  end


  def create_bank_billet
    @bank_slips = BankSlip.where('contract_id = ?', params[:cod]).order('due_at ASC')
    @keys = [:name, :url]
    @values = []

    @bank_slips.each do |bank_slip|

      if bank_slip.status == 'generating'

        @contract = Contract.find(bank_slip.contract_id)
        @debtor = Debtor.find(@contract.debtor_id)
        customer = Customer.find(@debtor.customer_id)

        t = Debtor.new(:cnpj => @debtor.cnpj, :cpf => @debtor.cpf)
        
        unless t.cnpj.nil?
          if t.cnpj.valido?
            cnpj_cpf = @debtor.cnpj.to_s
          end
        end
        
        unless t.cpf.nil?
          if t.cpf.valido?
            cnpj_cpf = @debtor.cpf.to_s
          end
        end
  
        ActiveRecord::Base.transaction do
          bank_billet = BoletoSimples::BankBillet.create({
                            amount: bank_slip.amount_principal,
                            description: 'Servicos prestados conforme contrato',
                            expire_at: bank_slip.due_at,
                            customer_address: @debtor.address,
                            customer_address_complement: @debtor.address_complement,
                            customer_city_name: @debtor.city_name,
                            customer_cnpj_cpf: cnpj_cpf,
                            customer_neighborhood: @debtor.neighborhood.nil? ? ' ' : @debtor.neighborhood,
                            customer_person_name: @debtor.name,
                            customer_person_type: 'individual',
                            customer_state: @debtor.state,
                            customer_zipcode: @debtor.zipcode,
                            bank_billet_account_id: 1502,
                            instructions: 'Parcela ' << bank_slip.ticket_number.to_s
                          })

          if bank_billet.persisted?
            bank_slip.status = :generating
            bank_slip.origin_code = bank_billet.id
            bank_slip.our_number = bank_billet.our_number
            bank_slip.shorten_url = bank_billet.formats["pdf"]
            bank_slip.save!
          else
            puts "Erro :("
            puts bank_billet.response_errors
          end
        end
      else
        @contract = Contract.find(bank_slip.contract_id)
        @debtor = Debtor.find(@contract.debtor_id)
        @values << [bank_slip.customer_person_name << '_' << bank_slip.our_number, bank_slip.shorten_url] if bank_slip.status == :opened
      end
    end

    if @values.present?
      require "open-uri"
      require 'zip'
      
      zipfile_name = "tmp/boletos_do_contribuinte_" + @debtor.origin_code.to_s + ".zip"

      if File.exist? zipfile_name
          logger.info zipfile_name.inspect
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @debtor.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
      else
        @values.each do |filename,url|
          image_url = URI.parse(url)
          logger.info image_url.inspect
          file = Tempfile.new
          file.binmode
          file.write open(image_url).read

          Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
            zipfile.add(filename + '.pdf', file)
          end
          
          file.close!
        end
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @debtor.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
      end
    end
  end


  def create_contract_from_proposal
    cod = params[:cod]
    proposal = Proposal.find cod

    if proposal.contract?
      flash[:alert] = "Ação não permitida. Proposta ja gerou um CONTRATO NRO " << proposal.contract_id.to_s
      redirect_to :proposals and return
    end 

    tickets = Ticket.where('unit_id = ? and customer_id = ? and proposal_id = ?', current_user.unit_id, session[:customer_id], cod)
    unit = Unit.find(current_user.unit_id)
    proposal_tickets = ProposalTicket.where('proposal_id = ?', cod)
    customer = Customer.find session[:customer_id]
    debtor = Debtor.find(proposal.debtor_id)


    client_amount = 0
    proposal_tickets.each  do |tic|
      client_amount = client_amount + tic['amount'].to_f
    end

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = current_user.unit_id
      @contract.customer_id = session[:customer_id]
      @contract.debtor_id = proposal.debtor_id
      @contract.user_id = current_user.id
      @contract.amount_principal = client_amount
      @contract.ticket_quantity = session[:bank_slips].count
      @contract.status = :open
      @contract.save!

      proposal_tickets.each  do |tic|
        bank_slip = BankSlip.new
        bank_slip.unit_id = current_user.unit_id
        bank_slip.customer_id = @contract.customer_id
        bank_slip.debtor_id = @contract.debtor_id
        bank_slip.bank_account_id = customer.bank_account_id
        bank_slip.contract_id = @contract.id

        bank_slip.amount_principal = tic['amount'].to_f
        bank_slip.due_at = tic['due_at']

        bank_slip.customer_name = customer[:name]
        bank_slip.customer_document = customer[:cnpj].present? ? customer[:cnpj] : customer[:cpf]
        bank_slip.status = :generating

        bank_slip.save!
      end

      tickets.each do  |ticket|
        ticket.contract_id = @contract.id
        ticket.contract!
        ticket.save!

        contract_ticket = ContractTicket.new
        contract_ticket.unit_id = current_user.unit_id
        contract_ticket.contract_id = @contract.id
        contract_ticket.ticket_id = ticket.id
        contract_ticket.customer_id = customer.id
        contract_ticket.debtor_id = debtor.id
        contract_ticket.amount_principal = ticket.amount_principal
        contract_ticket.amount_monetary_correction = Ticket.calc_amount_monetary_correction(ticket, nil, nil, false)
        contract_ticket.amount_interest = Ticket.calc_amount_interest(ticket, nil, nil, true, false)
        contract_ticket.amount_fine = Ticket.calc_amount_fine(ticket, nil, nil, true, true, false)
        contract_ticket.amount_tax = Ticket.calc_amount_tax(ticket, nil, nil, false, true, true, true)
        contract_ticket.save!

      end

      proposal.contract_id = @contract.id
      proposal.contract!
      proposal.save!
      
    end
    respond_with @contract, notice: 'Contrato criado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit(:unit_id, :amount_unit, :amount_client, :status, :debtor_id, :client_ticket_quantity)
    end
end
