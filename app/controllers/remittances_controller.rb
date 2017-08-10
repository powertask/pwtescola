class RemittancesController < ApplicationController
  before_action :authenticate_user!
  respond_to :html
  layout 'window'

  def index
    @remittances = BoletoSimples::Remittance.all(page: 1, per_page: 5)
     
    respond_with @remittances, :layout => 'application'
  end

  def remittance_new
  end

  def remittance_create
    @remittance = BoletoSimples::Remittance.create(bank_billet_account_id: 1502)

  	if @remittance.persisted?
  	  puts "Sucesso :)"
  	  puts @remittance.attributes
  	else
  	  puts "Erro :("
  	  puts @remittance.response_errors
  	end
  end

  def remittance_download
  	remittance = BoletoSimples::Remittance.find(params[:cod])
  	redirect_to remittance.url
  end

end
