class CreateProposal < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals do |t|
      t.references :unit, foreign_key: true
      t.references :user, foreign_key: true
      t.references :debtor, foreign_key: true
      t.float :unit_amount
      t.float :unit_fee
      t.integer :unit_ticket_quantity
      t.integer :client_ticket_quantity
      t.float :client_amount
      t.date :unit_due_at
      t.date :client_due_at
      t.integer :status

      t.timestamps null: false
    end
  end
end
