class History < ApplicationRecord
  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor

  def self.list(unit, customer, debtor)
    self.where("unit_id = ? and customer_id = ? AND debtor_id = ?", unit, customer, debtor)
  end

end
