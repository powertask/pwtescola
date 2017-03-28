class HistoriesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html
  layout 'window'


  def new_history
    @history = History.new
    @history.unit_id = current_user.unit_id
    @history.customer_id = session[:customer_id]
    @history.debtor_id = params[:debtor_id]
    @history.user_id = current_user.id
    @history.history_date = Time.current
  end

  def create_history
    @history = History.new(history_params)
    @history.save
    redirect_to( show_path(params[:debtor_id]) )
  end

  private

    def history_params
      params.require(:history).permit(:description, :history_date, :unit_id, :customer_id, :debtor_id, :user_id)
    end
end
