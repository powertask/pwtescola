class BankAccount < ActiveRecord::Base
  belongs_to :unit

  validates_presence_of :unit_id, :name
 
end
