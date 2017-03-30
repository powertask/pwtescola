class Debtor < ApplicationRecord
  include ActiveModel::Validations
  validates_with DebtorValidator

  validates_presence_of :unit_id, :customer_id, :address, :address_number, :state, :city_name
  validates :address_number, numericality: { only_integer: true }

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  belongs_to :unit
  belongs_to :customer

  has_many :tickets
  has_many :histories

  def self.list(unit, customer)
  	self.where('unit_id = ? AND customer_id = ?', unit, customer)
  end

end
