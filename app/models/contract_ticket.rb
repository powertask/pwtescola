class ContractTicket < ApplicationRecord
  belongs_to :unit
  belongs_to :ticket

  enum status: [:open, :paid]

  def self.list(unit, customer)
  	self.where('unit_id = ? and customer_id = ?', unit, customer)
  end
end
