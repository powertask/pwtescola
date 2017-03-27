class AddTaxToContractTicket < ActiveRecord::Migration[5.0]
  def change
  	add_column :contract_tickets, :amount_tax, :decimal
  end
end
