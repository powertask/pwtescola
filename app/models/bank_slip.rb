class BankSlip < ActiveRecord::Base
  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor
  belongs_to :bank_account
  belongs_to :contract

  validates_presence_of :unit_id, :customer_id, :due_at, :status

  enum status: [:generating, :open, :canceled, :paid, :overdue, :blocked, :chargeback]

  def self.list(unit, customer)
    self.where("unit_id = ? AND customer_id = ?", unit, customer)
  end
  
end
