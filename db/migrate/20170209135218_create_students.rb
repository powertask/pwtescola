class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.references :unit, foreign_key: true
      t.references :customer, foreign_key: true, index: true
      t.references :debtor, foreign_key: true, index: true
      t.references :course, foreign_key: true
      t.string :name
      t.string :cpf
    end
  end
end
