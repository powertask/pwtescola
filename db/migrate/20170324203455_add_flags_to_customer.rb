class AddFlagsToCustomer < ActiveRecord::Migration[5.0]
  def change
      add_column :customers, :fl_charge_monetary_correction, :boolean
      add_column :customers, :fl_charge_interest, :boolean
      add_column :customers, :fl_charge_fine, :boolean
      add_column :customers, :fl_charge_tax, :boolean
  end
end
