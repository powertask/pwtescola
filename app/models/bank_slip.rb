class BankSlip < ActiveRecord::Base
  belongs_to :unit
  belongs_to :customer
  belongs_to :debtor
  belongs_to :bank_account
  belongs_to :contract

  validates_presence_of :unit_id, :due_at, :contract_id, :status

  enum status: [:generating, :opened, :canceled, :paid, :overdue, :blocked, :chargeback, :legacy]

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end
