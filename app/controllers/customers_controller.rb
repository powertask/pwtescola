class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'

  def index
    @customers = index_list(Customer)
    respond_with @customers, :layout => 'application'
  end

  def show
  end

  def new
    @customer = Customer.new
    @customer.unit_id = current_user.unit_id
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    respond_with @customer
  end

  def update
    if @customer.update(customer_params)
      
      session[:customer_name] = @customer.name
      session[:fl_charge_monetary_correction] = @customer.fl_charge_monetary_correction
      session[:fl_charge_interest] = @customer.fl_charge_interest
      session[:fl_charge_fine] = @customer.fl_charge_fine
      session[:fl_charge_tax] = @customer.fl_charge_tax
    end
    respond_with @customer
  end


  def list_customers
    @customers = Customer.select('id', 'name').list(current_user.unit_id)

    unit = Unit.find current_user.unit_id
    session[:header_name] = unit.name
  end

  def define_customer
    customer = Customer.find params[:customer][:customer_id]

    if customer.present?
      session[:header_name] = customer.name
      session[:customer_id] = customer.id
      session[:customer_name] = customer.name
      session[:fl_charge_monetary_correction] = customer.fl_charge_monetary_correction
      session[:fl_charge_interest] = customer.fl_charge_interest
      session[:fl_charge_fine] = customer.fl_charge_fine
      session[:fl_charge_tax] = customer.fl_charge_tax

    end
    redirect_to root_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:unit_id, :name, :cnpj, :cpf, :zipcode, :state, :city_name, :address, :address_number, :address_complement, :neighborhood, :email, :phone_number, :created_at, :fl_charge_monetary_correction, :fl_charge_interest, :fl_charge_fine, :fl_charge_tax)
    end
end
