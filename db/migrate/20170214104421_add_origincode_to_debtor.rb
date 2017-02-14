class AddOrigincodeToDebtor < ActiveRecord::Migration[5.0]
  def change
  	add_column :debtors, :origin_code, :string
  end
end
