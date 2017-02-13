# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unit	=	Unit.create!(	name: 'Gianelli Martins Advogados',
							cnpj_cpf: '04307840000152'	)

User.create!(	email: 'marcelo@powertask.com.br', 
				password: 'galotito', 
				password_confirmation: 'galotito', 
				name: 'Marcelo Reichert', 
				profile: 0,
				unit_id: unit.id)

User.create!(	email: 'luciano@powertask.com.br', 
				password: 'galotito', 
				password_confirmation: 'galotito', 
				name: 'luciano Monaco', 
				profile: 0,
				unit_id: unit.id)

User.create!(	email: 'bruna.santos@gianellimartins.com.br', 
				password: 'BrunaSantos', 
				password_confirmation: 'BrunaSantos', 
				name: 'Bruna Santos', 
				profile: 0,
				unit_id: unit.id)

User.create!(	email: 'edinara.spanholi@gianellimartins.com.br', 
				password: 'EdinaraSpanholi', 
				password_confirmation: 'EdinaraSpanholi', 
				name: 'Edinara Spanholi', 
				profile: 0,
				unit_id: unit.id)



Customer.create!(	name: 'Colegio Santa Ines',
					full_name: 'COLEGIO STA INES ESCOLA DE 1 E 2 GRAUS',
					unit_id: unit.id)

Customer.create!(	name: 'Colegio Farroupilha',
					full_name: 'COLEGIO FARROUPILHA',
					unit_id: unit.id)
