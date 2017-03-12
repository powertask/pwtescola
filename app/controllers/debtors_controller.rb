class DebtorsController < ApplicationController
  before_action :set_debtor, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'

  def index
    @debtors = index_class(Debtor)
#    @debtors = Debtor.where('unit_id = ? and customer_id = ?', current_user.unit_id, session[:customer_id]).paginate(:page => params[:page], :per_page => 20)
    respond_with @debtors, :layout => 'application'
  end

  def show
    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], @debtor.id)
  end

  def new
    @debtor = Debtor.new
    @debtor.unit_id = current_user.unit_id
    @debtor.customer_id = session[:customer_id]
  end

  def edit
  end

  def create
    @debtor = Debtor.new(debtor_params)

    respond_to do |format|
      if @debtor.save
        format.html { redirect_to @debtor, notice: 'Debtor was successfully created.' }
        format.json { render :show, status: :created, location: @debtor }
      else
        format.html { render :new }
        format.json { render json: @debtor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @debtor.update(debtor_params)
        format.html { redirect_to @debtor, notice: 'Debtor was successfully updated.' }
        format.json { render :show, status: :ok, location: @debtor }
      else
        format.html { render :edit }
        format.json { render json: @debtor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @debtor.destroy
    respond_to do |format|
      format.html { redirect_to debtors_url, notice: 'Debtor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_debtor
      @debtor = Debtor.find(params[:id])
    end

    def debtor_params
      params.require(:debtor).permit(:unit_id, :customer_id, :name, :cnpj, :cpf, :zipcode, :state, :city_name, :address, :address_number, :address_complement, :neighborhood, :email, :phone_number)
    end
end
