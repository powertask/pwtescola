json.extract! customer, :id, :name, :cnpj, :zipcode, :state, :city, :address, :complement, :neighborhood, :email, :phone, :created_at, :updated_at
json.url customer_url(customer, format: :json)