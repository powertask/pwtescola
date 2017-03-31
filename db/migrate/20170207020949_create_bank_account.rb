class CreateBankAccount < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.references :unit, foreign_key: true
      t.string :name
      t.string :bank_code


      t.timestamps
      
    end
  end
end
