json.extract! ticket, :id, :description, :amount, :debtor_id, :document_number, :due_at, :charge, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)