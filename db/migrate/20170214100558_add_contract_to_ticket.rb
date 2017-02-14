class AddContractToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_reference :tickets, :contract, foreign_key: true
  end
end
