class AddStatusToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :status, :integer
  end
end
