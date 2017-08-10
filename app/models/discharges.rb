class Discharge < ActiveRecord::Base

  enum status: [:unprocessed, :processed]

end
