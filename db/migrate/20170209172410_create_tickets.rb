class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :unit, foreign_key: true
      t.references :debtor, foreign_key: true, index: true
      t.references :customer, foreign_key: true, index: true
      t.references :contract, foreign_key: true
      t.string :description
      t.decimal :amount_principal, default: 0
      t.string :document_number
      t.date :due_at
      t.boolean :charge, default: false
      t.string :origin_code
      t.integer :sequence
      t.integer :status

      t.timestamps
    end
  end
end
