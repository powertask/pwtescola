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
   
    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], params[:cod]).order('document_number')
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

=begin
    unless current_user.admin?
      if @taxpayer.user_id != current_user.id
        flash[:alert] = "Devedor não pertence a sua lista."
        redirect_to :root and return
      end
    end
=end 

=begin
    unless Taxpayer.chargeble? @taxpayer
      flash[:alert] = "Cidade não liberada para negociações!"
      redirect_to show_path(params[:cod]) and return 
    end
=end

    @histories = History.list(current_user.unit_id, session[:customer_id], params[:cod]).order('created_at DESC')

    @contract = Contract.new

    @tickets = Ticket.list(current_user.unit_id, session[:customer_id], params[:cod]).open.order('document_number')
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
    ticket_quantity  =  params[:ticket_quantity].to_i
    ticket_due_at    =  params[:ticket_due].to_date

    if params[:value_type].to_i == 0
      total_ticket_a_vista = session[:total_ticket_a_vista].to_f
      total_fee = session[:total_fee_a_vista].to_f.round(2)
      ticket_total = total_ticket_a_vista - total_fee      
    else
      total_ticket_cobrado = session[:total_ticket_cobrado].to_f
      total_fee = (session[:total_fee_cobrado].to_f).round(2)
      ticket_total = total_ticket_cobrado - total_fee      
    end

    ticket_amount = ticket_total / ticket_quantity
    @tickets = []

    (1..ticket_quantity).each  do |tic|
      due_at = ticket_due_at if tic == 1
      due_at = ticket_due_at + (tic - 1).month if tic > 1

      ticket = { ticket: tic, amount: ticket_amount.round(2), due_at: due_at}
      @tickets << ticket
      session[:tickets] = @tickets
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
    session[:total_correcao] = 0
    session[:total_ticket] = 0

    session[:value_ticket_cobrado] = 0
    session[:total_multa_cobrado] = 0
    session[:total_juros_cobrado] = 0
    session[:total_correcao_cobrado] = 0
    session[:total_ticket_cobrado] = 0
    session[:total_ticket_sem_fee_cobrado] = 0
    session[:total_fee_cobrado] = 0

    session[:value_ticket_a_vista] = 0
    session[:total_multa_a_vista] = 0
    session[:total_juros_a_vista] = 0
    session[:total_correcao_a_vista] = 0
    session[:total_ticket_a_vista] = 0
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
