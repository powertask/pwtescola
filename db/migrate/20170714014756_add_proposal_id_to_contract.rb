class AddProposalIdToContract < ActiveRecord::Migration[5.0]
  def change
  	add_reference :proposals, :contract, index: true, foreign_key: true
  end
end
