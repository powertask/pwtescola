# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


unit = Unit.create!(	name: 'Colégio Demonstração Ltda',
				cnpj_cpf: '05948748000140'	)

User.create!(	email: 'demonstracao@powertask.com.br', 
				password: 'demonstracao123', 
				password_confirmation: 'demonstracao123', 
				name: 'Usuário Demonstracao', 
				profile: 0,
				unit_id: unit.id)

Customer.create!(	name: 'Colegio Demonstração Ltda - Unidade Sul',
					full_name: 'Colegio Demonstração Ltda - Unidade Sul',
					unit_id: unit.id)

Customer.create!(	name: 'Colegio Demonstração Ltda - Unidade Norte',
					full_name: 'Colegio Demonstração Ltda - Unidade Sul',
					unit_id: unit.id)


MonetaryIndex.create!(index_at: Date.new(2013,12,1), value:	0.60)
MonetaryIndex.create!(index_at: Date.new(2013,11,1), value:	0.29)
MonetaryIndex.create!(index_at: Date.new(2013,10,1), value:	0.86)	
MonetaryIndex.create!(index_at: Date.new(2013,9,1), value:	1.50)	
MonetaryIndex.create!(index_at: Date.new(2013,8,1), value:	0.15)	
MonetaryIndex.create!(index_at: Date.new(2013,7,1), value:	0.26)	
MonetaryIndex.create!(index_at: Date.new(2013,6,1), value:	0.75)	
MonetaryIndex.create!(index_at: Date.new(2013,5,1), value:	0.00)	
MonetaryIndex.create!(index_at: Date.new(2013,4,1), value:	0.15)	
MonetaryIndex.create!(index_at: Date.new(2013,3,1), value:	0.21)	
MonetaryIndex.create!(index_at: Date.new(2013,2,1), value:	0.29)	
MonetaryIndex.create!(index_at: Date.new(2013,1,1), value:	0.34)	

MonetaryIndex.create!(index_at: Date.new(2014,12,1), value:	0.62)
MonetaryIndex.create!(index_at: Date.new(2014,11,1), value:	0.98)
MonetaryIndex.create!(index_at: Date.new(2014,10,1), value:	0.28)	
MonetaryIndex.create!(index_at: Date.new(2014,9,1), value:	0.20)	
MonetaryIndex.create!(index_at: Date.new(2014,8,1), value:	-0.27)	
MonetaryIndex.create!(index_at: Date.new(2014,7,1), value:	-0.61)	
MonetaryIndex.create!(index_at: Date.new(2014,6,1), value:	-0.74)	
MonetaryIndex.create!(index_at: Date.new(2014,5,1), value:	-0.13)	
MonetaryIndex.create!(index_at: Date.new(2014,4,1), value:	0.78)	
MonetaryIndex.create!(index_at: Date.new(2014,3,1), value:	1.67)	
MonetaryIndex.create!(index_at: Date.new(2014,2,1), value:	0.38)	
MonetaryIndex.create!(index_at: Date.new(2014,1,1), value:	0.48)	

MonetaryIndex.create!(index_at: Date.new(2015,12,1), value: 0.49)
MonetaryIndex.create!(index_at: Date.new(2015,11,1), value: 1.52)
MonetaryIndex.create!(index_at: Date.new(2015,10,1), value: 1.89) 
MonetaryIndex.create!(index_at: Date.new(2015,9,1), value:  0.95) 
MonetaryIndex.create!(index_at: Date.new(2015,8,1), value:  0.28)  
MonetaryIndex.create!(index_at: Date.new(2015,7,1), value:  0.69)  
MonetaryIndex.create!(index_at: Date.new(2015,6,1), value:  0.67)  
MonetaryIndex.create!(index_at: Date.new(2015,5,1), value:  0.41)  
MonetaryIndex.create!(index_at: Date.new(2015,4,1), value:  1.17) 
MonetaryIndex.create!(index_at: Date.new(2015,3,1), value:  0.98) 
MonetaryIndex.create!(index_at: Date.new(2015,2,1), value:  0.27) 
MonetaryIndex.create!(index_at: Date.new(2015,1,1), value:  0.76) 

MonetaryIndex.create!(index_at: Date.new(2016,12,1), value: 0.54)
MonetaryIndex.create!(index_at: Date.new(2016,11,1), value: -0.03)
MonetaryIndex.create!(index_at: Date.new(2016,10,1), value: 0.16) 
MonetaryIndex.create!(index_at: Date.new(2016,9,1), value:  0.20) 
MonetaryIndex.create!(index_at: Date.new(2016,8,1), value:  0.15)  
MonetaryIndex.create!(index_at: Date.new(2016,7,1), value:  0.18)  
MonetaryIndex.create!(index_at: Date.new(2016,6,1), value:  1.69)  
MonetaryIndex.create!(index_at: Date.new(2016,5,1), value:  0.82)  
MonetaryIndex.create!(index_at: Date.new(2016,4,1), value:  0.33) 
MonetaryIndex.create!(index_at: Date.new(2016,3,1), value:  0.51) 
MonetaryIndex.create!(index_at: Date.new(2016,2,1), value:  1.29) 
MonetaryIndex.create!(index_at: Date.new(2016,1,1), value:  1.14) 

MonetaryIndex.create!(index_at: Date.new(2017,2,1), value:  0.08) 
MonetaryIndex.create!(index_at: Date.new(2017,1,1), value:  0.64) 
