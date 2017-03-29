class ContractTicket < ApplicationRecord
  belongs_to :unit
  belongs_to :ticket

  def self.list(unit)
  	self.where('unit_id = ?', unit)
  end
end
