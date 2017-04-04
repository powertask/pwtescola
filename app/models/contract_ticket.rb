class ContractTicket < ApplicationRecord
  belongs_to :unit
  belongs_to :ticket
  belongs_to :contract

  enum status: [:open, :paid]

  validates_presence_of :unit_id, :debtor_id, :customer_id
 
  def self.list(unit, customer)
  	self.where('unit_id = ? and customer_id = ?', unit, customer)
  end
end
