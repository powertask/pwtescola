module ApplicationHelper


  def calc_meses_atraso(ticket, _dt_ini, _dt_end)
    _dt_ini = ticket.created_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    return 0
  end


  def calc_correcao(ticket, _dt_ini, _dt_end) 
  
  	return 0

    return 0 unless current_user.unit.fl_correcao
    
    _dt_ini = Date.new(ticket.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _dt_ini = Date.new(_dt_ini.year, _dt_ini.month, 1)
    _dt_end = Date.new(_dt_end.year, _dt_end.month, 1) + 1.month - 1.day
    _value = ticket.amount

    inpcs = Inpc.where("idx_date between ? AND ?", _dt_ini, _dt_end)
    idx_sum = 0

    inpcs.each do |inpc|
      _value = _value + (_value * (inpc.idx/100))
    end
    
    (_value.to_f - ticket.amount).round(2)
  end


  def calc_multa(cna, _dt_ini, _dt_end)

  	return 0

    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    _value = cna.amount + calc_correcao(cna, _dt_ini, _dt_end).to_f

  	_months = calc_meses_atraso(cna, _dt_ini, _dt_end)
    _perc = (10 + ((_months - 1) * 2)).round(2)
    _new_value = (_value * (_perc / 100)).round(2)
  end


  def calc_juros(cna, _dt_ini, _dt_end)

  	return 0

    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    _value = cna.amount + calc_correcao(cna, _dt_ini, _dt_end).to_f

    _months = calc_meses_atraso(cna, _dt_ini, _dt_end)
    _perc = (_months * 0.01).round(2)
    _new_value = (_value * _perc).round(2)
  end


  def calc_ticket(ticket, _dt_ini, _dt_end)

    _dt_ini = ticket.created_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    
    _correcao = calc_correcao(ticket, _dt_ini, _dt_end)
    _multa    = calc_multa(ticket, _dt_ini, _dt_end)
    _juros    = calc_juros(ticket, _dt_ini, _dt_end)

    total     = ticket.amount + _correcao + _multa + _juros

    if ticket.charge
      total_cobrado = total
    else
      total_cobrado = 0
    end

    session[:value_ticket]   = (session[:value_ticket].nil? ? 0 : session[:value_ticket]) + (ticket.amount.nil? ? 0 : ticket.amount)
    session[:total_multa]    = (session[:total_multa].nil? ? 0 : session[:total_multa]) + (_multa.nil? ? 0 : _multa)
    session[:total_juros]    = (session[:total_juros].nil? ? 0 : session[:total_juros]) + (_juros.nil? ? 0 : _juros)
    session[:total_correcao] = (session[:total_correcao].nil? ? 0 : session[:total_correcao]) + (_correcao.nil? ? 0 : _correcao)
    session[:total_ticket]   = (session[:total_ticket].nil? ? 0 : session[:total_ticket]) + (total.nil? ? 0 : total)

    if ticket.charge
      session[:value_ticket_cobrado]         = session[:value_ticket_cobrado].to_f + (ticket.amount.nil? ? 0 : ticket.amount)
      session[:total_multa_cobrado]       = session[:total_multa_cobrado].to_f + (_multa.nil? ? 0 : _multa)
      session[:total_juros_cobrado]       = session[:total_juros_cobrado].to_f + (_juros.nil? ? 0 : _juros)
      session[:total_correcao_cobrado]    = session[:total_correcao_cobrado].to_f + (_correcao.nil? ? 0 : _correcao)
      session[:total_ticket_sem_fee_cobrado] = session[:total_ticket_sem_fee_cobrado].to_f + (total.nil? ? 0 : total)
      session[:total_fee_cobrado]         = 0
      session[:total_ticket_cobrado]         = session[:total_ticket_sem_fee_cobrado].to_f + session[:total_fee_cobrado].to_f 

      session[:total_juros_a_vista]    = session[:total_juros_cobrado].to_f - (session[:total_juros_cobrado].to_f * 0.2).round(2)
      session[:total_multa_a_vista]    = session[:total_multa_cobrado].to_f - (session[:total_multa_cobrado].to_f * 0.2).round(2)
      
      session[:total_ticket_a_vista]      = session[:value_ticket_cobrado].to_f + 
                                         session[:total_correcao_cobrado].to_f + 
                                         session[:total_multa_a_vista].to_f + 
                                         session[:total_juros_a_vista].to_f 
                                         
      session[:total_ticket_sem_fee_a_vista] = session[:total_ticket_a_vista].to_f
      
      session[:total_fee_a_vista]      = 0
      session[:total_ticket_a_vista]      = session[:total_ticket_a_vista].to_f + session[:total_fee_a_vista].to_f

    end
    total
	end

end
