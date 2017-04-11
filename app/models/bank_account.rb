class BankAccount < ActiveRecord::Base
  belongs_to :unit

  has_many :customers
  
  validates_presence_of :unit_id, :name, :bank_billet_account
 
end
