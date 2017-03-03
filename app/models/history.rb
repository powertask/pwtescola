class History < ApplicationRecord
  belongs_to :unit
  belongs_to :customer

  def self.list(unit, customer)
    self.where("unit_id = ? and customer_id = ?", unit, customer)
  end

end
