json.extract! history, :id, :description, :history_date, :unit_id, :customer_id, :created_at, :updated_at
json.url history_url(history, format: :json)