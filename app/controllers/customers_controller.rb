class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  respond_to :html
  layout 'window'

  def index
    @customers = index_class(Customer)
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
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
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
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
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
      params.require(:customer).permit(:unit_id, :name, :cnpj, :cpf, :zipcode, :state, :city_name, :address, :address_number, :address_complement, :neighborhood, :email, :phone_number, :created_at)
    end
end
