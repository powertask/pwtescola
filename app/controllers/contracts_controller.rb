class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show]
  respond_to :html
  layout 'window'
  

  def index
    @contracts = Contract.list(current_user.unit_id, session[:customer_id]).paginate(:page => params[:page], :per_page => 20)
  end


  def show
    @contract = Contract.where('id = ? AND unit_id = ? AND customer_id = ?', params[:id].to_i, current_user.unit_id, session[:customer_id]).first
    @contract_tickets = ContractTicket.list(current_user.unit_id).where("contract_id = ?", params[:id])
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


  def create_bank_slip
    @ticket = Ticket.where('contract_id = ?', params[:cod]).order('due ASC')
    @keys = [:name, :url]
    @values = []

    @ticket.each do |ticket|
      if ticket.bank_billet_id.blank? || ticket.bank_billet_id.nil?
        @contract = Contract.find(ticket.contract_id)
        @taxpayer = Taxpayer.find(@contract.taxpayer_id)
        client = Client.find(@taxpayer.client_id)
        bank_billet_account = BankBilletAccount.find(client.bank_billet_account_id)
        bank_billet_account_unit = BankBilletAccount.find_by(bank_billet_account: session[:unit_bank_billet_account])
        cna = Cna.select('year').where('contract_id = ?', ticket.contract_id)

        t = Taxpayer.new(:cnpj => @taxpayer.cnpj, :cpf => @taxpayer.cpf)
        
        unless t.cnpj.nil?
          if t.cnpj.valido?
            cnpj_cpf = @taxpayer.cnpj.to_s
          end
        end
        
        unless t.cpf.nil?
          if t.cpf.valido?
            cnpj_cpf = @taxpayer.cpf.to_s
          end
        end
  
        ActiveRecord::Base.transaction do
          bank_billet = BoletoSimples::BankBillet.create({
                            amount: ticket.amount,
                            description: 'Servicos prestados conforme contrato',
                            expire_at: ticket.due,
                            customer_address: @taxpayer.address,
                            customer_address_complement: @taxpayer.complement,
                            customer_city_name: @taxpayer.city.name,
                            customer_cnpj_cpf: cnpj_cpf,
                            customer_neighborhood: @taxpayer.neighborhood.nil? ? ' ' : @taxpayer.neighborhood,
                            customer_person_name: @taxpayer.name,
                            customer_person_type: 'individual',
                            customer_state: @taxpayer.city.state,
                            customer_zipcode: @taxpayer.zipcode,
                            bank_billet_account_id: (ticket.ticket_type == 'client' ? bank_billet_account.bank_billet_account : bank_billet_account_unit.bank_billet_account),
                            instructions: 'Parcela ' << ticket.ticket_number.to_s << ' referente ao(s) ano(s) de ' << cna.collect {|i| i.year}.sort.join(',')
                          })

          if bank_billet.persisted?
            
            bank_billet_pwt = BankBillet.new( :unit_id => session[:unit_id], 
                                              :bank_billet_account_id => (ticket.ticket_type == 'client' ? bank_billet_account.id : bank_billet_account_unit.id), 
                                              :origin_code => bank_billet.id, 
                                              :our_number => bank_billet.our_number, 
                                              :amount => bank_billet.amount, 
                                              :expire_at => bank_billet.expire_at, 
                                              :customer_person_name => bank_billet.customer_person_name,
                                              :customer_cnpj_cpf => bank_billet.customer_cnpj_cpf,
                                              :status => (bank_billet.status == 'generating' ? 0 : bank_billet.status), 
                                              :shorten_url => bank_billet.formats["pdf"], 
                                              :fine_for_delay => bank_billet.fine_for_delay, 
                                              :late_payment_interest => bank_billet.late_payment_interest, 
                                              :document_date => bank_billet.document_date, 
                                              :document_amount => bank_billet.document_amount)

            bank_billet_pwt.save!

            ticket.bank_billet_id = bank_billet_pwt.id
            ticket.status = 0  # Gerando
            ticket.save!

          else
            puts "Erro :("
            puts bank_billet.response_errors
          end
        end
      else
        @contract = Contract.find(ticket.contract_id)
        @taxpayer = Taxpayer.find(@contract.taxpayer_id)
        bank_billet = BankBillet.find(ticket.bank_billet_id)
        @values << [bank_billet.customer_person_name << '_' << bank_billet.our_number, bank_billet.shorten_url] if bank_billet.status == 'opened'
      end
    end

    if @values.present?
      require "open-uri"
      require 'zip'
      
      zipfile_name = "tmp/boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip"

      if File.exist? zipfile_name
          logger.info zipfile_name.inspect
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
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
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
      end
    end
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
