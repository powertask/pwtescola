class AddClientToProposal < ActiveRecord::Migration[5.0]
  def change
  	add_reference :proposals, :customer, index: true, foreign_key: true
  end
end
