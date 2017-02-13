class AddUnitToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :unit, foreign_key: true
  end
end
