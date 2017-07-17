class Proposal < ActiveRecord::Base
  belongs_to :unit
  belongs_to :debtor
  belongs_to :user
  belongs_to :contract
  belongs_to :customer
  
  has_many :tickets
  
  validates_presence_of :unit_id, :debtor_id, :customer_id

	enum status: [:active, :cancel, :contract]

  def self.list(unit, customer)
    self.where("unit_id = ? and customer_id = ?", unit, customer)
  end
  
end
