desc "Import data"
task :import => :environment do

  begin

    ActiveRecord::Base.transaction do

      puts "Import data from MYSQL....."

      puts "Create.....UNIT"
      unit = Unit.new
      unit.name = "Gianelli Martins Advogados"
      unit.cnpj_cpf = "04307840000152"
      unit.state = "RS"
      unit.save!

      puts "Create.....BANK ACCOUNT"
      bank = BankAccount.new
      bank.unit_id = unit.id
      bank.name = "Banco do Brasil"
      bank.bank_code = "1188"
      bank.save!


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


      ## Import TICKETS
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
          ticket.amount_principal = j['tit_vpar'].to_f
          ticket.document_number = j['tit_numt']
          ticket.due_at = j['tit_dven']
          ticket.charge = false
          ticket.created_at = j['tit_dcad']
          ticket.sequence = j['tit_sequ']
          ticket.status = :open
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


      ## Import PAYMENT
      puts "Import data from MYSQL.....CONTRACT/BANK_SLIP"

      JSON.parse(File.read('lib/tasks/arccnab.json')).each do |j|

        debtor = Debtor.where('origin_code = ?', j['cnab_codi'].to_s)

        if debtor.present?

          contract = Contract.new
          contract.unit_id = debtor.first.unit_id
          contract.debtor_id = debtor.first.id
          contract.customer_id = debtor.first.customer_id
          contract.amount_principal = j['cnab_vpri'].to_f
          contract.amount_monetary_correction = j['cnab_vcom'].to_f
          contract.amount_interest = j['cnab_vjur'].to_f
          contract.amount_fine = j['cnab_vmul'].to_f
          contract.origin_code = j['cnab_nreci'].to_s
          contract.status = :legacy
          contract.ticket_quantity = j['cnab_qpar'].to_i
          contract.created_at = j['cnab_demt']

          contract.save!


          bank_slip = BankSlip.new
          bank_slip.unit_id = debtor.first.unit_id
          bank_slip.debtor_id = debtor.first.id
          bank_slip.customer_id = debtor.first.customer_id
          bank_slip.bank_account_id = BankAccount.all.first.id
          bank_slip.contract_id = contract.id
          bank_slip.origin_code = ''
          bank_slip.our_number = j['cnab_ntibr'].to_s
          bank_slip.amount_principal = j['cnab_vpar'].to_f
          bank_slip.due_at = j['cnab_dvep']
          bank_slip.customer_name = j['cnab_nome']
          bank_slip.customer_document = j['cnab_cpfc']
          bank_slip.paid_at = j['cnab_dcrep']
          bank_slip.paid_amount_principal = j['cnab_vpagp'].to_f
          bank_slip.status = :legacy

          bank_slip.save!
        end
      end


      ## Import PAYMENT
      puts "Import data from MYSQL.....CONTRACT TICKET"

      JSON.parse(File.read('lib/tasks/arcpag.json')).each do |j|

        debtor = Debtor.where('origin_code = ?', j['pag_codi'].to_s)
        ticket = Ticket.where('unit_id = ? AND debtor_id = ? AND sequence = ?', debtor.first.unit_id, debtor.first.id, j['pag_sequ'].to_i)
        contract = Contract.where('origin_code = ?', j['pag_reci'].to_s)

        contract_ticket = ContractTicket.new
        contract_ticket.unit_id = debtor.first.unit_id
        contract_ticket.contract_id = contract.first.id if contract.present?
        contract_ticket.ticket_id = ticket.first.id
        contract_ticket.amount_principal = j['pag_vpri'].to_f
        contract_ticket.amount_monetary_correction = j['pag_vcom'].to_f
        contract_ticket.amount_interest = j['pag_vjur'].to_f
        contract_ticket.amount_fine = j['pag_vmul'].to_f

        contract_ticket.save!

      end

    end

    rescue ActiveRecord::RecordInvalid => e
      puts e.record.errors.full_messages      

  end
end
