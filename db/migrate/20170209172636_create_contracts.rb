class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :amount_unit
      t.string :amount_client
      t.string :status
      t.string :customer_ticket_quantity
      t.string :unit_ticket_quantity

      t.timestamps
    end
  end
end
