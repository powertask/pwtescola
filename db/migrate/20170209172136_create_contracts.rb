class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :debtor, foreign_key: true, index: true
      t.decimal :amount_principal
      t.decimal :amount_monetary_correction
      t.decimal :amount_interest
      t.decimal :amount_fine
      t.integer :status
      t.integer :ticket_quantity
      t.string :origin_code

      t.timestamps
    end
  end
end
