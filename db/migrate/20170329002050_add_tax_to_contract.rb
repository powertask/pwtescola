class AddTaxToContract < ActiveRecord::Migration[5.0]
  def change
  	add_column :contracts, :amount_tax, :decimal
  end
end
