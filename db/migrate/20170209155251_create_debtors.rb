class CreateDebtors < ActiveRecord::Migration[5.0]
  def change
    create_table :debtors do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :name
      t.string :cnpj
      t.string :cpf
      t.string :zipcode
      t.string :city_name
      t.string :state
      t.string :address
      t.integer :address_number
      t.string :address_complement
      t.string :neighborhood
      t.string :email
      t.string :phone_local_code
      t.string :phone_number
      t.string :mobile_local_code
      t.string :mobile_number

      t.timestamps
    end
  end
end
