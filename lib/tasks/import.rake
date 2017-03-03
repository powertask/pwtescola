desc "Import data"
task :import => :environment do

  begin
    puts "Import data from MYSQL....."

    ActiveRecord::Base.transaction do

      puts "Import data from MYSQL.....UNIT"
      unit = Unit.new
      unit.name = "Gianelli Martins Advogados"
      unit.cnpj_cpf = "04307840000152"
      unit.state = "RS"
      unit.save!


      puts "Import data from MYSQL.....USERS"
      user = User.new
      user.unit_id = unit.id
      user.profile = 0
      user.name = 'Marcelo Reichert'
      user.email = "marcelo@powertask.com.br"
      user.password = "galotito"
      user.save!      


      ## Import CUSTOMERS
      puts "Import data from MYSQL.....CUSTOMERS"
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
        customer.unit_id = unit.id
        customer.full_name = nome
        customer.name = nome
        customer.zipcode = cep
        customer.city_name = cidade
        customer.state = uf
        customer.address = endereco
        customer.neighborhood = bairro
        customer.created_at = cad
        customer.origin_code = codi

        if cgc.length == 14
          customer.cnpj = cgc
        elsif cgc.length == 11
          customer.cpf = cgc
        end

        customer.save!
      end

      ## Import DEBTORS
      puts "Import data from MYSQL.....DEBTORS"
      arcdevs = Arcdev.all

      arcdevs.each do |d|

        cod = d.dev_codi
        nome = d.dev_nome
        cgc = d.dev_cgc.to_i.to_s
        cep = d.dev_cepr.to_i.to_s
        cidade = d.dev_cidr
        uf = d.dev_ufr
        endereco = d.dev_logr
        complemento = d.dev_comr
        bairro = d.dev_bair
        cod_cliente = d.dev_clie
        telefone = d.dev_telr
        data_cadastro = d.dev_dcad

        customer = Customer.where(origin_code: cod_cliente)


        if customer.present?

          debtor = Debtor.new

          if cgc.length == 14
            debtor.cnpj = cgc
            debtor.cnpj = nil unless debtor.cnpj.valido?

          elsif cgc.length == 11
            debtor.cpf = cgc
            debtor.cpf = nil unless debtor.cpf.valido?
          end

          debtor.unit_id = unit.id
          debtor.customer_id =  customer.first.id
          debtor.name = nome
          debtor.zipcode = cep 
          debtor.city_name = cidade
          debtor.state = uf
          debtor.address = endereco
          debtor.address_complement = complemento
          debtor.neighborhood = bairro
          debtor.origin_code = cod
          debtor.phone_number = telefone
          debtor.created_at = data_cadastro

          debtor.save!
        end
      end

      ## Import TIT
     puts "Import data from MYSQL.....TICKETS"
     arctits = Arctit.all

      unit = Unit.all.first

      arctits.each do |t|
        origin_code_debtor = t.tit_codi.to_i
        origin_code_customer = t.tit_clie.to_i
        document_number = t.tit_numt
        amount = t.tit_vpar
        due_at = t.tit_dven
        created_at = t.tit_dcad

        debtor = Debtor.where(origin_code: origin_code_debtor)
        customer = Customer.where(origin_code: origin_code_customer)

        if debtor.present? && customer.present?

          ticket = Ticket.new
          ticket.unit_id = unit.id
          ticket.debtor_id = debtor.first.id
          ticket.customer_id = customer.first.id
          ticket.description = document_number
          ticket.amount = amount.to_f
          ticket.document_number = document_number
          ticket.due_at = due_at
          ticket.charge = 0
          ticket.created_at = created_at
          ticket.status = :opened
          ticket.save!
        end
      end

    end

    rescue ActiveRecord::RecordInvalid => e
      puts e.record.errors.full_messages      

  end
end
