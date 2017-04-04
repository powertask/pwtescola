class CreateContractTicket < ActiveRecord::Migration[5.0]
  def change
    create_table :contract_tickets do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :debtor, foreign_key: true
      t.references :contract, foreign_key: true
      t.references :ticket, foreign_key: true, index: true
      t.decimal :amount_principal, default: 0
      t.decimal :amount_monetary_correction, default: 0
      t.decimal :amount_interest, default: 0
      t.decimal :amount_fine, default: 0
      t.decimal :amount_tax, default: 0
      t.integer :status
    end
  end
end
