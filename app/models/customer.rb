class Customer < ApplicationRecord
  validates_presence_of :name, :unit_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  belongs_to :unit
  belongs_to :bank_account

  has_many :debtors
  has_many :tickets

  def self.list(unit)
    self.where("unit_id = ? and fl_show = ?", unit, true).order("name ASC")
  end

end
