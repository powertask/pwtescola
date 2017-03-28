class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'

  def index
    @customers = Customer.where(id: session[:customer_id])
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

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Cliente criado com sucesso.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @customer.update(customer_params)
        
        session[:customer_name] = @customer.name
        session[:fl_charge_monetary_correction] = @customer.fl_charge_monetary_correction
        session[:fl_charge_interest] = @customer.fl_charge_interest
        session[:fl_charge_fine] = @customer.fl_charge_fine
        session[:fl_charge_tax] = @customer.fl_charge_tax

        format.html { redirect_to @customer, notice: 'Cliente atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end


  def list_customers
    @customers = Customer.select('id', 'name').where(origin_code: [10,4,13])
  end

  def define_customer
    customer = Customer.find params[:customer][:customer_id]

    if customer.present?
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
