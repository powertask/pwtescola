class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string  :name
      t.string  :cnpj_cpf
      t.string  :zipcode
      t.string  :state
      t.string  :city_name
      t.string  :address
      t.string  :address_complement
      t.integer :address_number
      t.string  :neighborhood
      t.string  :email

      t.timestamps
    end
  end
end
