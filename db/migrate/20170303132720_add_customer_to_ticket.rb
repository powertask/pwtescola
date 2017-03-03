class AddCustomerToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_reference :tickets, :customer, index: true, foreign_key: true
  end
end
