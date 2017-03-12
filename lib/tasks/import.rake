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

      user = User.new
      user.unit_id = unit.id
      user.profile = 0
      user.name = 'Luciano Monaco'
      user.email = "luciano@powertask.com.br"
      user.password = "galotito"
      user.save!      

      ## Import USERS
      puts "Import data from MYSQL.....USERS"

      JSON.parse(File.read('lib/tasks/arccobr.json')).each do |j|
        user = User.new
        user.unit_id = unit.id
        user.profile = 1
        user.name = j['cob_nome']
        user.origin_code = j['cob_codi']
        user.password = '12345678'
        user.email = 'teste'<<j['cob_codi']<<'@powertask.com.br'
        
        if j['cob_codi'] == '13'
          user.email = "bruna.santos@gianellimartins.com.br"
          user.password = "BrunaSantos"
        end
        
        if j['cob_codi'] == '14'
          user.email = "edinara.spanholi@gianellimartins.com.br"
          user.password = "EdinaraSpanholi"
        end
        
        user.save!   
      end



      ## Import CUSTOMERS
      puts "Import data from MYSQL.....CUSTOMERS"

      JSON.parse(File.read('lib/tasks/arccli.json')).each do |j|
        customer = Customer.new
        customer.unit_id = unit.id
        customer.full_name = j['cli_nome']
        customer.name = j['cli_nome']
        customer.zipcode = j['cli_cep'].to_i.to_s
        customer.city_name = j['cli_cida']
        customer.state = j['cli_uf']
        customer.address = j['cli_ende']
        customer.neighborhood = j['cli_bair']
        customer.created_at = j['cli_dcad']
        customer.origin_code = j['cli_codi']

        cnpj_cpf = j['cli_cgc'].to_i.to_s

        if cnpj_cpf.length == 14
          customer.cnpj = cnpj_cpf
        elsif cnpj_cpf.length == 11
          customer.cpf = cnpj_cpf
        end

        customer.save!
      end



      ## Import DEBTORS
      puts "Import data from MYSQL.....DEBTORS"

      JSON.parse(File.read('lib/tasks/arcdev.json')).each do |j|

        customer = Customer.where(origin_code: j['dev_clie'])

        if customer.present?

          debtor = Debtor.new

          cnpj_cpf = j['dev_cgc'].to_i.to_s

          if cnpj_cpf.length == 14
            debtor.cnpj = cnpj_cpf
            debtor.cnpj = nil unless debtor.cnpj.valido?

          elsif cnpj_cpf.length == 11
            debtor.cpf = cnpj_cpf
            debtor.cpf = nil unless debtor.cpf.valido?
          end

          debtor.unit_id = unit.id
          debtor.customer_id =  customer.first.id
          debtor.name = j['dev_nome']
          debtor.zipcode = j['dev_cepr'].to_i.to_s 
          debtor.city_name = j['dev_cidr']
          debtor.state = j['dev_ufr']
          debtor.address = j['dev_logr']
          debtor.address_complement = j['dev_comr']
          debtor.neighborhood = j['dev_bair']
          debtor.origin_code = j['dev_codi']
          debtor.phone_number = j['dev_telr']
          debtor.created_at = j['dev_dcad']

          debtor.save!
        end
      end


      ## Import TIT
      puts "Import data from MYSQL.....TICKETS"
     
      JSON.parse(File.read('lib/tasks/arctit.json')).each do |j|

        debtor = Debtor.where(origin_code: j['tit_codi'].to_s)
        customer = Customer.where(origin_code: j['tit_clie'])

        if debtor.present? && customer.present?

          ticket = Ticket.new
          ticket.unit_id = unit.id
          ticket.debtor_id = debtor.first.id
          ticket.customer_id = customer.first.id
          ticket.description = j['tit_numt']
          ticket.amount = j['tit_vpar'].to_f
          ticket.document_number = j['tit_numt']
          ticket.due_at = j['tit_dven']
          ticket.charge = false
          ticket.created_at = j['tit_dcad']
          ticket.status = 0
          ticket.save!
        end
      end


      ## Import HISTORY
      puts "Import data from MYSQL.....HISTORIES"

      JSON.parse(File.read('lib/tasks/arcacie.json')).each do |j|

        unit     = Unit.all.first
        customer = Customer.where('origin_code = ?', j['acie_clie'])
        debtor   = Debtor.where('origin_code = ?', j['acie_codi'].to_s)
        user     = User.where('origin_code = ?', j['acie_cobr'])

        if customer.present? && debtor.present? && user.present?

          h = History.new
          h.unit_id = unit.id
          h.customer_id = customer.first.id
          h.debtor_id = debtor.first.id
          h.user_id = user.first.id
          h.description = j['acie_comm']
          h.history_date = (j['acie_dlan'] + ' ' + j['acie_dhor']).to_datetime
          h.save!

        end
      end


    end

    rescue ActiveRecord::RecordInvalid => e
      puts e.record.errors.full_messages      

  end
end
