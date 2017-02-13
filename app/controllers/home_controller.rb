 class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :get_dashboard_data, only: [:index, :filter_name]

  respond_to :html, :js, :json

  layout 'application'

  def index

    if session[:customer_id].nil?
      redirect_to(:controller => 'customers', :action => 'list_customers')
      return
    end

  end


  def filter_name
    
    if params[:name].present?

      if params[:name].size < 3
        flash[:alert] = "Nome do devedor deve conter ao menos 3 letras."
        redirect_to :root and return
      end 

      @debtors = Debtor
                      .where("unit_id = ? AND customer_id = ? AND lower(debtors.name) like ?", current_user.unit_id, session[:customer_id], "%"<< params[:name].downcase << "%")
                      .paginate(:page => params[:page], :per_page => 5)
                      .order('name ASC')

    elsif params[:cpf].present?

      unless params[:cpf].size == 14
        flash[:alert] = "CPF deve conter 11 números no formato 999.999.999-99"
        redirect_to :root and return
      end 

      @debtors = Debtor
                      .where("unit_id = ? AND customer_id = ? AND debtors.cpf = ?", current_user.unit_id, session[:customer_id], params[:cpf])
                      .paginate(:page => params[:page], :per_page => 5)
                      .order('name ASC')

    end

    if @debtors.nil? || @debtors.empty?
      flash[:alert] = "Devedor não encontrado."
      redirect_to :root and return
    end 
  
    render "index", :layout => 'application'
  end


  def show
    @debtor = Debtor.find(params[:cod])
   
    @tickets = Ticket.list(current_user.unit_id, session[:client_id]).where('debtor_id = ?', params[:cod])
    @contracts = Contract.list(current_user.unit_id, session[:client_id]).where('debtor_id = ?', params[:cod])
    
    clear_variable_session()
    contracts_meter

    @histories = History.list(current_user.unit_id, session[:client_id]).where('debtor_id = ?', params[:cod]).order('created_at DESC')

    session[:debtor_id] = params[:cod]

    render "index", :layout => 'application'
  end


  def deal
    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end

    if @date_current < Date.current
      flash[:alert] = "Data base não pode ser menor que data atual"
      @date_current = nil
      redirect_to deal_path(params[:cod]) and return 
    end

    if current_user.client?
      flash[:alert] = "Não permitido acessar Ambiente de Negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @taxpayer = Taxpayer.find(params[:cod])

    unless current_user.admin?
      if @taxpayer.user_id != current_user.id
        flash[:alert] = "Devedor não pertence a sua lista."
        redirect_to :root and return
      end
    end
 
    unless Taxpayer.chargeble? @taxpayer
      flash[:alert] = "Cidade não liberada para negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @areas = Area.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order('year DESC, nr_document')
    @histories = History.list(session[:unit_id], session[:client_id]).where('taxpayer_id = ?', params[:cod]).order('created_at DESC')

    @contract = Contract.new
    @contract.unit_ticket_quantity = 1
    @contract.client_ticket_quantity = 1

    @cnas = Cna.list(session[:unit_id], session[:client_id]).not_pay.where('taxpayer_id = ?', params[:cod]).order(:year)
    @cna = Cna.new

    clear_variable_session()

    respond_with @taxpayer, :layout => 'application'     
  end


  def get_cna
    @cna = Cna.find(params[:cod])
  end

  
  def pay_cna
    if current_user.id == 1
      @cna = Cna.find(params[:cod])
      @cna.pay!

      redirect_to show_path(@cna.taxpayer_id) and return
    end
  end


  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)

    @cnas = Cna.list(session[:unit_id], session[:client_id]).not_pay.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)
    @taxpayer = Taxpayer.find @cna.taxpayer.id

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end
    
    clear_variable_session()

  end


  def get_tickets
    unit_ticket_quantity  =  params[:unit_ticket_quantity].to_i
    unit_ticket_due       =  params[:unit_ticket_due].to_date
    client_ticket_due     =  params[:client_ticket_due].to_date

    if params[:value_type].to_i == 0
      total_cna_a_vista = session[:total_cna_a_vista].to_f
      total_fee = session[:total_fee_a_vista].to_f.round(2)
      total_cna = total_cna_a_vista - total_fee      
    else
      total_cna_cobrado = session[:total_cna_cobrado].to_f
      total_fee = (session[:total_fee_cobrado].to_f).round(2)
      total_cna = total_cna_cobrado - total_fee      
    end

    cna_ticket = total_cna / unit_ticket_quantity.to_i
    @tickets = []

    unit_ticket_quantity  = unit_ticket_quantity + 1

    (1..unit_ticket_quantity).each  do |tic|
      unit_due = unit_ticket_due if tic == 1
      client_due = client_ticket_due if tic == 2
      client_due = client_ticket_due + (tic - 2).month if tic > 2

      ticket = { ticket: tic, unit_amount: total_fee, client_amount: 0.00, due: unit_due} if tic == 1
      ticket = { ticket: tic, unit_amount: 0.00, client_amount: cna_ticket.round(2), due: client_due} if tic > 1
      @tickets << ticket
      session[:tickets] = @tickets
    end
  end

  
  def get_tasks
    
    @tasks = Task.where("unit_id = ? AND user_id = ? AND task_date >= ?", session[:unit_id], current_user.id, Date.current - 1.day).order('id ASC')

    tasks = []
    @tasks.each do |task|
      tasks << {:id => task.id, 
                :title => task.description, 
                :start => "#{task.task_date.to_date}", 
                :end => "#{task.task_date.to_date}", 
                :allDay => true, 
                :recurring => false,
                :url => Rails.application.routes.url_helpers.show_path(task.taxpayer_id),
                :color => "green"
              }
    end
    render :text => tasks.to_json
  end


  def get_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
  end

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
    @taxpayer.update_attributes(taxpayer_params)
  end


  def get_client_session
    @clients = Client.all.select('id', 'name')
  end

  def set_client
    session[:client_id] = params[:client][:client_id]
    redirect_to root_path
  end

  def get_new_unit
    flash[:alert] = nil
    session[:unit_profile] = params[:profile]
    respond_with(@unit, layout: "unit")
  end



  private
  def cna_params
    params.require(:cna).permit(:fl_charge)
  end

  def taxpayer_params
    params.require(:taxpayer).permit(:phone)
  end

  def clear_variable_session

    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_correcao] = 0
    session[:total_cna] = 0

    session[:value_cna_cobrado] = 0
    session[:total_multa_cobrado] = 0
    session[:total_juros_cobrado] = 0
    session[:total_correcao_cobrado] = 0
    session[:total_cna_cobrado] = 0
    session[:total_cna_sem_fee_cobrado] = 0
    session[:total_fee_cobrado] = 0

    session[:value_cna_a_vista] = 0
    session[:total_multa_a_vista] = 0
    session[:total_juros_a_vista] = 0
    session[:total_correcao_a_vista] = 0
    session[:total_cna_a_vista] = 0
    session[:total_fee_a_vista] = 0

  end

  def get_dashboard_data 
    @count_contracts_day = 0
    @count_contracts_month = 0

    #dt_ini = Date.new(Date.current.year, Date.current.month, 1).beginning_of_day
    #dt_end = Date.current.end_of_day

    #@count_contracts_day        = Contract.list(current_user.unit_id],session[:customer_id]).active.where('contract_date between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).count
    #@count_contracts_month      = Contract.list(current_user.unit_id],session[:customer_id]).active.where('contract_date between ? AND ?', dt_ini, dt_end ).count
    #@count_contracts_day_master = Contract.list(current_user.unit_id],session[:customer_id]).active.where('contract_date between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
    #@histories                  = History.list(current_user.unit_id],session[:customer_id]).where('history_date is not null').order('history_date DESC').limit(30)

    #@resume = Cna.find_by_sql(['select u.id, (select count(1) from histories where histories.history_date between ? AND ? AND histories.user_id = u.id) count_histories_today, count(1), sum(amount), u.name from cnas c, taxpayers t, cities ct, users u where c.taxpayer_id = t.id and t.user_id = u.id and c.status = 0 and t.city_id = ct.id and ct.fl_charge = ? AND t.client_id = ? group by u.name, u.id order by u.name', Date.current.beginning_of_day, Date.current.end_of_day, true, session[:client_id]])

    #@count_contracts_month_master = Contract.active.where('unit_id = ? AND client_id = ? AND contract_date between ? AND ?', session[:unit_id], session[:client_id], dt_ini, dt_end).group('user_id').count

    #@count_contracts_day_master = @count_contracts_day_master.map{|z|z}
    #@count_contracts_month_master = @count_contracts_month_master.map{|z|z}

  end
end
