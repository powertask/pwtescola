class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'
  
  def index
    @tickets = Ticket.all
  end

  def show
  end

  def new
    @ticket = Ticket.new
    @ticket.unit_id = current_user.unit_id
    @ticket.status = :open
    @ticket.debtor_id = params[:format]
    @ticket.customer_id = session[:customer_id]
    @ticket.charge = false
    @debtor = Debtor.find params[:format]
  end

  def edit
    @debtor = Debtor.find @ticket.debtor_id
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.save!

    @debtor = Debtor.find(@ticket.debtor_id)
    respond_with @debtor
  end


  def update
    @ticket.update_attributes(ticket_params)
    redirect_to( debtor_path( @ticket.debtor.id ) )
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:unit_id, :customer_id, :debtor_id, :status, :description, :amount_principal, :document_number, :due_at, :charge)
    end
end
