class AddDebtorToContract < ActiveRecord::Migration[5.0]
  def change
  	add_reference :contracts, :debtor, index: true, foreign_key: true
  end
end
