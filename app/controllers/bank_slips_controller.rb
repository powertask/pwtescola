class BankSlipsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html
  layout 'window'

  def index

    if params[:filter].nil? or params[:filter][:status].nil? or params[:filter][:status].downcase == 'todos status...'
      
      if current_user.admin?
        @bank_slips = BankSlip.where("unit_id = ? AND customer_id = ?", current_user.unit_id, session[:customer_id]).order('due_at DESC').paginate(:page => params[:page], :per_page => 20)
        status_counter
      end

    else
      status = 0 if params[:filter][:status].downcase == 'gerando'
      status = 1 if params[:filter][:status].downcase == 'aberto'
      status = 2 if params[:filter][:status].downcase == 'cancelado'
      status = 3 if params[:filter][:status].downcase == 'pago'
      status = 4 if params[:filter][:status].downcase == 'vencido'
      status = 5 if params[:filter][:status].downcase == 'bloqueado'
      status = 6 if params[:filter][:status].downcase == 'devolucao'

      if current_user.admin?
        @bank_slips = BankSlip.where("unit_id = ? AND customer_id = ? AND status = ?", current_user.unit_id, session[:customer_id], status).order('due_at DESC').paginate(:page => params[:page], :per_page => 20)
        status_counter
      end     
    end
    respond_with @bank_slips, :layout => 'application'
  end



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

    def status_counter 
      @count_open = BankSlip.open.where("unit_id = ? AND customer_id = ?", current_user.unit_id, session[:customer_id]).count
      @count_overdue = BankSlip.overdue.where("unit_id = ? AND customer_id = ?", current_user.unit_id, session[:customer_id]).count
      @count_paid = BankSlip.paid.where("unit_id = ? AND customer_id = ?", current_user.unit_id, session[:customer_id]).count
    end

end
