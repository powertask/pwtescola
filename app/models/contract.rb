class Contract < ApplicationRecord
  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor

	validates_presence_of :unit_id, :customer_id, :debtor_id, :status

  enum status: [:open, :cancel, :paid, :legacy]

  def self.list(unit, customer)
    self.where("unit_id = ? AND customer_id = ?", unit, customer)
  end

end
