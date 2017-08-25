class ProposalsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html
  layout 'window'

  def index
    if current_user.admin? || current_user.client?
      @proposals = Proposal.where("unit_id = ? and customer_id = ?", current_user.unit_id, session[:customer_id]).order('id DESC').paginate(:page => params[:page], :per_page => 20)
    else
      @proposals = Proposal.where("unit_id = ? and customer_id = ? AND user_id = ?", current_user.unit_id, session[:customer_id], current_user.id).order('id DESC').paginate(:page => params[:page], :per_page => 20)
    end
    respond_with @proposals, :layout => 'application'
  end

  def show
    @proposal = Proposal.where('id = ? and unit_id = ? and customer_id = ?', params[:id].to_i, current_user.unit_id, session[:customer_id]).first
    @proposal_tickets = ProposalTicket.list(params[:id]).order('ticket_number')
    respond_with @proposal
  end

  def create_proposal
    cod = params[:cod]

    debtor = Debtor.find(cod)
    tickets = Ticket.list(current_user.unit_id, session[:customer_id], cod).not_pay.where('charge = ?', true)
    unit = Unit.find(current_user.unit_id)

    ActiveRecord::Base.transaction do
      @proposal = Proposal.new

      @proposal.unit_id = current_user.unit_id
      @proposal.customer_id = session[:customer_id]
      @proposal.user_id = current_user.id
      @proposal.debtor_id = cod
      
      unit_amount = session[:total_fee_cobrado].to_f
      @proposal.unit_amount = unit_amount.round(2)

      client_amount = session[:total_ticket_cobrado].to_f
      @proposal.client_amount = client_amount.round(2)
      @proposal.client_ticket_quantity = session[:bank_slips].count
      
      @proposal.unit_ticket_quantity = 1
      @proposal.unit_fee = 10
      @proposal.status = 0

      @proposal.save!

      n = 0
      session[:bank_slips].each  do |tic|
        n = n + 1
        @ticket = ProposalTicket.new
        @ticket.unit_id = current_user.unit_id
        @ticket.proposal_id = @proposal.id
        
        @ticket.amount = tic['amount'].to_f if tic['amount'].to_f > 0
        @ticket.due_at = tic['due_at'].to_date
        @ticket.ticket_number = n

        @ticket.save!
      end

      tickets.each do  |ticket|
        ticket.proposal_id = @proposal.id
        ticket.proposal!
        ticket.save!
      end
    end
    respond_with @proposal, notice: 'Proposta criada com sucesso.'
  end


  def cancel_proposal
    cod = params[:cod]
    proposal = Proposal.find(cod)

    if proposal.contract?
      flash[:alert] = "Ação não permitida. Proposta ja gerou um TERMO NRO " << proposal.contract_id.to_s
      redirect_to :proposals and return
    end 

    if proposal.cancel?
      flash[:alert] = "Ação não permitida. Proposta ja esta cancelada."
      redirect_to :proposals and return
    end 

    tickets = Ticket.list(current_user.unit_id, session[:customer_id], proposal.debtor_id).where('proposal_id = ?', cod)

    ActiveRecord::Base.transaction do
      tickets.each do  |ticket|
        ticket.proposal_id = nil
        ticket.status = :not_pay
        ticket.save!
      end

      proposal.status = :cancel
      proposal.save!
    end
    respond_with proposal, alert: 'Proposta CANCELADA com sucesso.'
  end

  private
  def proposal_params
    params.require(:proposal).permit(:unit_id, :customer_id, :user_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
