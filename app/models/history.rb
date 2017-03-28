class History < ApplicationRecord
  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor
  belongs_to :user

  def self.list(unit, customer, debtor)
    self.where("unit_id = ? and customer_id = ? AND debtor_id = ?", unit, customer, debtor)
  end

  def self.list_dashboard(unit, customer)
    self.where("unit_id = ? and customer_id = ?", unit, customer)
  end

end
