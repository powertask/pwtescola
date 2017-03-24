class CreateMonetaryIndex < ActiveRecord::Migration[5.0]
  def change
    create_table :monetary_indices do |t|
      t.date :index_at
      t.decimal :value, precision: 5, scale: 4
    end
  end
end
