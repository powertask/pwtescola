desc "Import data"
task :import => :environment do
  puts "Import data from MYSQL....."

  puts "Import data from MYSQL.....CUSTOMERS"
  ## Import Customers
  
  ActiveRecord::Base.transaction do

    arcclis = Arccli.all

    arcclis.each do |cli|
      codi = cli.cli_codi
      cgc = cli.cli_cgc.to_i.to_s
      nome = cli.cli_nome
      endereco = cli.cli_ende
      bairro = cli.cli_bair
      cidade = cli.cli_cida
      uf = cli.cli_uf
      cep = cli.cli_cep.to_i.to_s
      cad = cli.cli_dcad

      customer = Customer.new
      customer.unit_id = 1
      customer.full_name = nome
      customer.name = nome

      if cgc.length == 14
        customer.cnpj = cgc
      elsif cgc.length == 11
        customer.cpf = cgc
      end

      customer.zipcode = cep
      customer.city_name = cidade
      customer.state = uf
      customer.address = endereco
      customer.neighborhood = bairro
      customer.created_at = cad

      customer.save!

    end
  end


  puts "Import...OK"
end
