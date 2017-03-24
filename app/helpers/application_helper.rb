module ApplicationHelper


  def calc_meses_atraso(ticket, _dt_ini, _dt_end)
    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    (_dt_end.year * 12 + _dt_end.month) - (_dt_ini.year * 12 + _dt_ini.month)
  end


  def calc_correcao(ticket, _dt_ini, _dt_end) 

    return 0 unless session[:fl_charge_monetary_correction]

    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _dt_ini = Date.new(_dt_ini.year, _dt_ini.month, 1)
    _dt_end = Date.new(_dt_end.year, _dt_end.month, 1) + 1.month - 1.day
    _value = ticket.amount_principal

    monetary_indexes = MonetaryIndex.where("index_at between ? AND ?", _dt_ini, _dt_end)
    idx_sum = 0

    monetary_indexes.each do |igpm|
      _value = _value + (_value * (igpm.value/100))
    end
    
    (_value.to_f - ticket.amount_principal).round(2)
  end


  def calc_multa(ticket, _dt_ini, _dt_end)
    
    return 0 unless session[:fl_charge_fine]

    _value = ticket.amount_principal + calc_juros(ticket, _dt_ini, _dt_end)
    (_value * 0.02).round(2)
  end


  def calc_juros(ticket, _dt_ini, _dt_end)

    return 0 unless session[:fl_charge_interest]

    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _value = ticket.amount_principal + calc_correcao(ticket, _dt_ini, _dt_end).to_f

    _months = calc_meses_atraso(ticket, _dt_ini, _dt_end)
    _perc = (_months * 0.01).round(2)
    _new_value = (_value * _perc).round(2)
  end


  def calc_taxa(ticket, _dt_ini, _dt_end)
    
    return 0 unless session[:fl_charge_tax]

    _principal  = ticket.amount_principal 
    _correcao   = calc_correcao(ticket, _dt_ini, _dt_end)
    _juros      = calc_juros(ticket, _dt_ini, _dt_end)
    _multa      = calc_multa(ticket, _dt_ini, _dt_end)
    _total      = _principal + _correcao + _juros + _multa
    (_total.to_f * 0.1).round(2)
  end


  def calc_ticket(ticket, _dt_ini, _dt_end)

    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    
    _principal  = ticket.amount_principal 
    _correcao   = calc_correcao(ticket, _dt_ini, _dt_end)
    _juros      = calc_juros(ticket, _dt_ini, _dt_end)
    _multa      = calc_multa(ticket, _dt_ini, _dt_end)
    _taxa       = calc_taxa(ticket, _dt_ini, _dt_end)

    total       = _principal + _correcao + _multa + _juros + _taxa

    if ticket.charge
      total_cobrado = total
    else
      total_cobrado = 0
    end

    session[:value_ticket]   = (session[:value_ticket].nil? ? 0 : session[:value_ticket]) + (_principal.nil? ? 0 : _principal)
    session[:total_multa]    = (session[:total_multa].nil? ? 0 : session[:total_multa]) + (_multa.nil? ? 0 : _multa)
    session[:total_juros]    = (session[:total_juros].nil? ? 0 : session[:total_juros]) + (_juros.nil? ? 0 : _juros)
    session[:total_taxa]     = (session[:total_taxa].nil? ? 0 : session[:total_taxa]) + (_taxa.nil? ? 0 : _taxa)
    session[:total_correcao] = (session[:total_correcao].nil? ? 0 : session[:total_correcao]) + (_correcao.nil? ? 0 : _correcao)
    session[:total_ticket]   = (session[:total_ticket].nil? ? 0 : session[:total_ticket]) + (total.nil? ? 0 : total)

    if ticket.charge
      session[:value_ticket_cobrado]  = session[:value_ticket_cobrado].to_f + (_principal.nil? ? 0 : _principal)

      session[:total_multa_cobrado]       = session[:total_multa_cobrado].to_f + (_multa.nil? ? 0 : _multa)
      session[:total_juros_cobrado]       = session[:total_juros_cobrado].to_f + (_juros.nil? ? 0 : _juros)
      session[:total_taxa_cobrado]       = session[:total_taxa_cobrado].to_f + (_taxa.nil? ? 0 : _taxa)
      session[:total_correcao_cobrado]    = session[:total_correcao_cobrado].to_f + (_correcao.nil? ? 0 : _correcao)
      session[:total_ticket_sem_fee_cobrado] = session[:total_ticket_sem_fee_cobrado].to_f + (total.nil? ? 0 : total)
      session[:total_fee_cobrado]         = 0
      session[:total_ticket_cobrado]         = session[:total_ticket_sem_fee_cobrado].to_f + session[:total_fee_cobrado].to_f 

      session[:total_juros_a_vista]    = session[:total_juros_cobrado].to_f - (session[:total_juros_cobrado].to_f * 0).round(2)
      session[:total_multa_a_vista]    = session[:total_multa_cobrado].to_f - (session[:total_multa_cobrado].to_f * 0).round(2)
      session[:total_taxa_a_vista]    = session[:total_taxa_cobrado].to_f - (session[:total_taxa_cobrado].to_f * 0).round(2)
      
      session[:total_ticket_a_vista]      = session[:value_ticket_cobrado].to_f + 
                                         session[:total_correcao_cobrado].to_f + 
                                         session[:total_multa_a_vista].to_f + 
                                         session[:total_taxa_a_vista].to_f + 
                                         session[:total_juros_a_vista].to_f 
                                         
      session[:total_ticket_sem_fee_a_vista] = session[:total_ticket_a_vista].to_f
      
      session[:total_fee_a_vista]      = 0
      session[:total_ticket_a_vista]      = session[:total_ticket_a_vista].to_f + session[:total_fee_a_vista].to_f

    end
    total
	end

end
