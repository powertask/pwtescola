class History < ApplicationRecord
  belongs_to :unit
  belongs_to :customer
end
