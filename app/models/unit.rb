class Unit < ApplicationRecord

	has_many :users
	has_many :debtors
	has_many :tickets

	validates_presence_of :name, :cnpj_cpf

end
