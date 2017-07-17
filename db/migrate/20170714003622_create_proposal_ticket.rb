class CreateProposalTicket < ActiveRecord::Migration[5.0]
  def change
    create_table :proposal_tickets do |t|
        t.references :unit, foreign_key: true
        t.references :proposal, foreign_key: true
    	t.integer :ticket_type
    	t.float :amount
    	t.integer :ticket_number
    	t.date :due_at

    	t.timestamps null: false
    end
  end
end
