class CreateCourse < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.references :unit, foreign_key: true
      t.string :name
    end
  end
end
