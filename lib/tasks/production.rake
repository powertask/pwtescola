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
        ticket   = Ticket.where('bank_slip_id = ?', i.id).first
        
        if ticket.present?
          contract   = Contract.find ticket.contract_id

          begin
            ActiveRecord::Base.transaction do
              bankslip.status = bankbillet_api.status
              bankslip.paid_at = bankbillet_api.paid_at
              bankslip.paid_amount = bankbillet_api.paid_amount
              bankslip.our_number = bankbillet_api.our_number
              bankslip.fine_for_delay = bankbillet_api.fine_for_delay
              bankslip.late_payment_interest = bankbillet_api.late_payment_interest
              bankslip.save!

              ticket.status = bankbillet_api.status
              ticket.paid_at = bankbillet_api.paid_at
              ticket.paid_amount = bankbillet_api.paid_amount

              ticket.save!

              if bankbillet_api.paid_amount > 0
                ticket_not_paid = Ticket.where('contract_id = ? AND status in (0,1,4)', ticket.contract_id)
                if ticket_not_paid.empty?
                  contract.status = :paid
                  contract.save!
                end
              end

              if bankslip.paid_amount > 0
                history = History.new
                history.description = 'Boleto ' << bankslip.our_number.to_s << ' pago no valor de R$ ' << bankslip.paid_amount.to_s
                history.history_date = Time.current
                history.unit_id = 1
                history.user_id = 1
                history.client_id = ticket.client_id
                history.taxpayer_id = contract.taxpayer_id
                history.save!
              end
            end
            rescue ActiveRecord::RecordInvalid => e
            puts e.record.errors.full_messages
          end
        end
      end
      sleep(1.second)
    end
  end
 
end

 
