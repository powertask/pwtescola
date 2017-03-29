namespace :db do

  desc "Update data"

  task :update => :environment do

    begin

      ActiveRecord::Base.transaction do

        puts "Update data....."


        contracts = Contract.all

        contracts.each do |contract|

          status = :paid

          bank_slips = BankSlip.where(contract_id: contract.id)
          bank_slips.each do |bank_slip|

            if bank_slip.paid_amount_principal > 0
              bank_slip.status = :paid
            else
              status = :not_paid
            end
            bank_slip.save!
          end

          if status == :paid
            contract.status = status
          else
            contract.status = :open
          end

          contract_tickets = ContractTicket.where(contract_id: contract.id)
          contract_tickets.each do |contract_ticket|

            ticket = Ticket.find contract_ticket.ticket_id
            ticket.contract_id = contract.id
            ticket.status = :paid
            ticket.save!
          end

          contract.save!

        end

      end

      rescue ActiveRecord::RecordInvalid => e
        puts e.record.errors.full_messages      

    end
  end
end
