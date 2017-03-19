class Ticket < ApplicationRecord
  belongs_to :debtor
  belongs_to :unit
  belongs_to :customer

  validates_presence_of :unit_id, :debtor_id, :customer_id, :amount_principal, :status, :description

  enum status: [:open, :paid, :contract, :proposal, :legacy]

  def self.list(unit, customer, debtor)
    self.where("unit_id = ? AND customer_id = ? AND debtor_id = ?", unit, customer, debtor)
  end
end
