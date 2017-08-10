class Remittance < ActiveRecord::Base

  enum status: [:unprocessed, :processed, :downloaded, :sent]

end
