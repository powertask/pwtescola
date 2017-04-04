class Course < ApplicationRecord

  validates_presence_of :unit_id, :name

  belongs_to :unit

  has_many :students
  has_many :tickets

  def self.list(unit)
    self.where('unit_id = ?', unit)
  end

end
