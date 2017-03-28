class BankSlipsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html
  layout 'window'

  def create
    @bank_slip = BankSlip.new(bank_slip_params)

    @bank_slip.save!
    respond_with @bank_slip
  end


  def create_new_due_at
    bank_slip = BankSlip.find(params[:cod])

    @contract = Contract.find bank_slip.contract_id
    
    @bank_slip = BankSlip.new
    @bank_slip.unit_id = bank_slip.unit_id
    @bank_slip.customer_id = bank_slip.customer_id
    @bank_slip.debtor_id = bank_slip.debtor_id
    @bank_slip.contract_id = bank_slip.contract_id
    @bank_slip.bank_account_id = bank_slip.bank_account_id
    @bank_slip.amount_principal = bank_slip.amount_principal
    @bank_slip.customer_name = bank_slip.customer_name
    @bank_slip.customer_document = bank_slip.customer_document
    @bank_slip.status = :generating

    respond_with @bank_slip
  end


  def show
    redirect_to(contracts_path)
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_slip_params
      params.require(:bank_slip).permit(:unit_id, :customer_id, :debtor_id, :bank_account_id, :amount_principal, :contract_id, :due_at, :customer_name, :customer_document, :status)
    end

end
