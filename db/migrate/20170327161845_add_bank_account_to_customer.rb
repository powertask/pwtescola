class AddBankAccountToCustomer < ActiveRecord::Migration[5.0]
  def change
  	add_reference :customers, :bank_account, foreign_key: true
  end
end
