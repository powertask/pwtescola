class Debtor < ApplicationRecord

  validates_presence_of :unit_id, :customer_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  belongs_to :unit
  belongs_to :customer

  has_many :tickets
  has_many :histories

end
