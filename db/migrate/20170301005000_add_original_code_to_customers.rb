class AddOriginalCodeToCustomers < ActiveRecord::Migration[5.0]
  def change
  	add_column :customers, :origin_code, :string
  end
end
