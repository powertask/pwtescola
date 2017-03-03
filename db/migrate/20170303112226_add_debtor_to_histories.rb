class AddDebtorToHistories < ActiveRecord::Migration[5.0]
  def change
  	add_reference :histories, :debtor, index: true, foreign_key: true
  end
end
