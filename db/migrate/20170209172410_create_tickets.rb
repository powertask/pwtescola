class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :unit, foreign_key: true
      t.references :debtor, foreign_key: true
      t.string :description
      t.decimal :amount
      t.string :document_number
      t.date :due_at
      t.integer :charge

      t.timestamps
    end
  end
end
