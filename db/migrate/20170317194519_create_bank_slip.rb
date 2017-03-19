class CreateBankSlip < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_slips do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :debtor, foreign_key: true
      t.references :bank_account, foreign_key: true
      t.references :contract, foreign_key: true
      t.integer :origin_code
      t.string :our_number
      t.decimal :amount_principal
      t.date :due_at
      t.string :customer_name
      t.string :customer_document
      t.date :paid_at
      t.decimal :paid_amount_principal
      t.string :shorten_url
      t.integer :status

      t.timestamps
    end
  end
end
