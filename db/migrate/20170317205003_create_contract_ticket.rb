class CreateContractTicket < ActiveRecord::Migration[5.0]
  def change
    create_table :contract_tickets do |t|
      t.references :unit, foreign_key: true
      t.references :contract, foreign_key: true
      t.references :ticket, foreign_key: true
      t.decimal :amount_principal
      t.decimal :amount_monetary_correction
      t.decimal :amount_interest
      t.decimal :amount_fine
    end
  end
end
