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
        flash[:alert] = "Nome do Responsável Financeiro deve conter ao menos 3 letras."
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
      flash[:alert] = "Responsável Financeiro não encontrado."
      redirect_to :root and return
    end 
  
    render "index", :layout => 'application'
  end


  def show
    @debtor = Debtor.find(params[:cod])
   
    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], params[:cod]).order('due_at, document_number')
    @contracts = Contract.list(current_user.unit_id, session[:customer_id]).where('debtor_id = ?', params[:cod])

    clear_variable_session
    #contracts_meter

    @histories = History.list(current_user.unit_id, session[:customer_id], params[:cod]).order('created_at DESC')

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

    @debtor = Debtor.find(params[:cod])

    @histories = History.list(current_user.unit_id, session[:customer_id], params[:cod]).order('created_at DESC')

    @contract = Contract.new

    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], params[:cod]).open.order('due_at, document_number')
    @ticket = Ticket.new

    clear_variable_session()

    respond_with @debtor, :layout => 'application'     
  end


  def get_charge_ticket
    @ticket = Ticket.find(params[:cod])
  end


  def set_charge_ticket
    @ticket = Ticket.find(params[:cod])
    @ticket.update_attributes(ticket_params)

    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], @ticket.debtor.id).open.order(:document_number, :due_at)
    @debtor = Debtor.find @ticket.debtor.id

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end
    
    clear_variable_session

  end


  def get_tickets_simul
    bank_slip_quantity  =  params[:simul][:bank_slip_quantity].to_i
    bank_slip_due_at    =  params[:simul][:bank_slip_due_at].to_date

    if bank_slip_quantity == 1
      total = session[:total_ticket_a_vista].to_f
    else
      total = session[:total_ticket_cobrado].to_f
    end

    amount = total / bank_slip_quantity
    @bank_slips = []

    (1..bank_slip_quantity).each  do |tic|
      due_at = bank_slip_due_at if tic == 1
      due_at = bank_slip_due_at + (tic - 1).month if tic > 1

      bank_slip = { id: tic, amount_principal: amount.round(2), due_at: due_at}
      @bank_slips << bank_slip
      session[:bank_slips] = @bank_slips
    end
  end


  def get_debtor
    @debtor = Debtor.find(params[:cod])
  end

  def set_debtor
    @debtor = Debtor.find(params[:cod])
    @debtor.update_attributes(debtor_params)
  end


  def get_client_session
    @clients = Client.all.select('id', 'name')
  end

  def set_customer
    session[:customer_id] = params[:customer][:customer_id]
    redirect_to root_path
  end

  def get_new_unit
    flash[:alert] = nil
    session[:unit_profile] = params[:profile]
    respond_with(@unit, layout: "unit")
  end



  private
  def ticket_params
    params.require(:ticket).permit(:charge)
  end

  def clear_variable_session

    session[:value_ticket] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_taxa] = 0
    session[:total_correcao] = 0
    session[:total_ticket] = 0

    session[:value_ticket_cobrado] = 0
    session[:total_multa_cobrado] = 0
    session[:total_juros_cobrado] = 0
    session[:total_correcao_cobrado] = 0
    session[:total_taxa_cobrado] = 0
    session[:total_ticket_cobrado] = 0
    session[:total_ticket_sem_fee_cobrado] = 0
    session[:total_fee_cobrado] = 0

    session[:value_ticket_a_vista] = 0
    session[:total_multa_a_vista] = 0
    session[:total_juros_a_vista] = 0
    session[:total_taxa_a_vista] = 0
    session[:total_correcao_a_vista] = 0
    session[:total_ticket_a_vista] = 0
    session[:total_fee_a_vista] = 0

  end

  def get_dashboard_data 
    @count_contracts_day = 0
    @count_contracts_month = 0

    dt_ini = Date.new(Date.current.year, Date.current.month, 1).beginning_of_day
    dt_end = Date.current.end_of_day

    @count_contracts_day        = Contract.list(current_user.unit_id,session[:customer_id]).open.where('created_at between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).count
    @count_contracts_month      = Contract.list(current_user.unit_id,session[:customer_id]).open.where('created_at between ? AND ?', dt_ini, dt_end ).count
    @count_contracts_day_master = Contract.list(current_user.unit_id,session[:customer_id]).open.where('created_at between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
    @histories                  = History.list_dashboard(current_user.unit_id, session[:customer_id]).where('history_date is not null').order('history_date DESC').limit(30)

    #@resume = Cna.find_by_sql(['select u.id, (select count(1) from histories where histories.history_date between ? AND ? AND histories.user_id = u.id) count_histories_today, count(1), sum(amount), u.name from cnas c, taxpayers t, cities ct, users u where c.taxpayer_id = t.id and t.user_id = u.id and c.status = 0 and t.city_id = ct.id and ct.fl_charge = ? AND t.client_id = ? group by u.name, u.id order by u.name', Date.current.beginning_of_day, Date.current.end_of_day, true, session[:client_id]])

    @count_contracts_month_master = Contract.list(current_user.unit_id, session[:customer_id]).open.where('created_at between ? AND ?', dt_ini, dt_end).group('user_id').count

    @count_contracts_day_master = @count_contracts_day_master.map{|z|z}
    @count_contracts_month_master = @count_contracts_month_master.map{|z|z}

  end
end
