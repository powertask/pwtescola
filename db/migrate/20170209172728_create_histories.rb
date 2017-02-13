class CreateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :description
      t.string :history_date

      t.timestamps
    end
  end
end
