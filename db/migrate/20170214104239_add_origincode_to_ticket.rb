class AddOrigincodeToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :origin_code, :string
  end
end
