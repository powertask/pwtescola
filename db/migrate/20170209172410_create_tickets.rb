class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :unit, foreign_key: true
      t.references :debtor, foreign_key: true
      t.string :description
      t.string :amount
      t.string :document_number
      t.string :due_at
      t.string :charge

      t.timestamps
    end
  end
end
