class Customer < ApplicationRecord
  validates_presence_of :name, :unit_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  belongs_to :unit

  has_many :debtors
  has_many :tickets

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end

end
