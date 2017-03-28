class ContractTicket < ApplicationRecord
  belongs_to :unit
  belongs_to :ticket

  def self.list(unit, customer)
  	self.where('unit_id = ? AND customer_id = ?', unit, customer)
  end
end
