class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :debtor, foreign_key: true, index: true
      t.decimal :amount_principal, default: 0
      t.decimal :amount_monetary_correction, default: 0
      t.decimal :amount_interest, default: 0
      t.decimal :amount_fine, default: 0
      t.integer :status
      t.integer :ticket_quantity
      t.string :origin_code

      t.timestamps
    end
  end
end
