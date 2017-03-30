class Ticket < ApplicationRecord
  belongs_to :debtor
  belongs_to :unit
  belongs_to :customer

  validates_presence_of :unit_id, :debtor_id, :customer_id, :amount_principal, :status, :description, :due_at

  enum status: [:open, :paid, :contract, :proposal, :legacy]

  def self.list(unit, customer, debtor)
    self.where("unit_id = ? AND customer_id = ? AND debtor_id = ?", unit, customer, debtor)
  end


  def self.calc_diff_months(ticket, _dt_ini, _dt_end)
    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _months = (_dt_end.year * 12 + _dt_end.month) - (_dt_ini.year * 12 + _dt_ini.month)

    return 0 if _months < 0
    _months
  end


  def self.calc_amount_monetary_correction(ticket, _dt_ini, _dt_end, _calc_amount_monetary_correction) 

    return 0 unless _calc_amount_monetary_correction

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


  def self.calc_amount_fine(ticket, _dt_ini, _dt_end, _calc_amount_fine, _calc_amount_interest, _calc_amount_monetary_correction)
    
    return 0 unless _calc_amount_fine

    _value = ticket.amount_principal + Ticket.calc_amount_interest(ticket, _dt_ini, _dt_end, _calc_amount_interest, _calc_amount_monetary_correction)
    (_value * 0.02).round(2)
  end


  def self.calc_amount_interest(ticket, _dt_ini, _dt_end, _calc_amount_interest, _calc_amount_monetary_correction)

    return 0 unless _calc_amount_interest

    _dt_ini = ticket.due_at if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _value = ticket.amount_principal + Ticket.calc_amount_monetary_correction(ticket, _dt_ini, _dt_end, _calc_amount_monetary_correction).to_f

    _months = Ticket.calc_diff_months(ticket, _dt_ini, _dt_end)
    _perc = (_months * 0.01).round(2)
    _new_value = (_value * _perc).round(2)
  end


  def self.calc_amount_tax(ticket, _dt_ini, _dt_end, _calc_amount_tax, _calc_amount_fine, _calc_amount_interest, _calc_amount_monetary_correction)
    
    return 0 unless _calc_amount_tax

    _principal  = ticket.amount_principal 
    _correcao   = Ticket.calc_amount_monetary_correction(ticket, _dt_ini, _dt_end, false)
    _juros      = Ticket.calc_amount_interest(ticket, _dt_ini, _dt_end, _calc_amount_interest, _calc_amount_monetary_correction)
    _multa      = Ticket.calc_amount_fine(ticket, _dt_ini, _dt_end, _calc_amount_fine, _calc_amount_interest, _calc_amount_monetary_correction)
    _total      = _principal + _correcao + _juros + _multa
    (_total.to_f * 0.1).round(2)
  end

end
