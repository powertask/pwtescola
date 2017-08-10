namespace :production do

  desc "Clears Rails tmp"
  task :clear_tmp => :environment do
     Dir["tmp/*.zip"].each do |i|
      puts 'Deleting file ' + i
      File.delete(i)
     end
     puts 'task completed with sucess!'
  end

  
  ## Executar apos a atualizaco dos tickets
  desc "Update contract status"
  task :update_contract_status => :environment do
    
    contracts = Contract.active

    contracts.each do |contract|
      tickets_open = Ticket.where('contract_id = ? AND status in (0,1,4)', contract.id)

      ActiveRecord::Base.transaction do

        if tickets_open.empty?
          contract.status = :paid
          contract.save!

          cnas = Cna.where('contract_id = ?', contract.id)
          cnas.each do |cna|
            cna.status = :pay
            cna.save!
          end
        end
      end
    end
  end


  desc "Update ticket status"
  task :update_bankslip_status => :environment do
    bank_billet_pwt = BankSlip.joins(:contract).where('bank_slips.unit_id = ? and bank_slips.customer_id = ? and bank_slips.origin_code > 0', 2, 4)

    bank_billet_pwt.each do |i|
      bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

      if bankbillet_api.present?
        bankslip = BankSlip.find(i.id)
        
        contract  = Contract.find bankslip.contract_id

        status = :open if bankbillet_api.status == 'opened'
        status = :generating if bankbillet_api.status == 'generating'
        status = :canceled if bankbillet_api.status == 'canceled'
        status = :paid if bankbillet_api.status == 'paid'
        status = :overdue if bankbillet_api.status == 'overdue'

        begin
          ActiveRecord::Base.transaction do
            bankslip.status = status
            bankslip.paid_at = bankbillet_api.paid_at
            bankslip.paid_amount_principal = bankbillet_api.paid_amount
            bankslip.save!

            if bankbillet_api.paid_amount > 0
              any_not_paid = BankSlip.where('contract_id = ? AND status in (0,1,4)', bankslip.contract_id)
              if any_not_paid.empty?
                contract.status = :paid
                contract.save!
              end
            end

          end
          rescue ActiveRecord::RecordInvalid => e
          puts e.record.errors.full_messages
        end
      end
      sleep(1.second)
    end
  end
 
end

 
