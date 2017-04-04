class Student < ApplicationRecord

  validates_presence_of :unit_id, :customer_id, :debtor_id, :name, :course_id

  usar_como_cpf :cpf

  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor
  belongs_to :course

  has_many :tickets

  def self.list(unit, customer, debtor)
    self.where('unit_id = ? AND customer_id = ? AND debtor_id = ?', unit, customer, debtor)
  end

end
