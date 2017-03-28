class BankSlipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_slip, only: [:show]

  respond_to :html
  layout 'window'

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
end
