class AddProposalIdToCna < ActiveRecord::Migration[5.0]
  def change
  	add_reference :tickets, :proposal, index: true, foreign_key: true
  end
end
