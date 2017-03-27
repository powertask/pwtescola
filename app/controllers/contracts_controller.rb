class ContractsController < ApplicationController
  before_action :set_contract, only: [:show]
  respond_to :html
  layout 'window'
  

  def index
    @contracts = Contract.all
  end


  def show
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
      @contract.ticket_quantity = session[:tickets].size
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
