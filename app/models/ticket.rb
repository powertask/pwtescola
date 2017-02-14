class Ticket < ApplicationRecord
  belongs_to :debtor
  belongs_to :unit

  validates_presence_of :unit_id, :debtor_id, :amount, :status, :description

  enum status: [:generated, :opened, :canceled, :paid, :overdue]

  def self.list(unit, debtor)
    self.where("unit_id = ? AND debtor_id = ?", unit, debtor)
  end
end
