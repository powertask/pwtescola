class UnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unit, only: [:show, :edit, :update]
  respond_to :html

  def index
    @units = Unit.find current_user.unit_id
  end

  def show
  end

  def edit
  end

  def update
    @unit.update(unit_params)
    respond_with @unit
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:name, :cnpj, :zipcode, :state, :city_name, :address, :complement, :neighborhood, :email)
    end
end
