class Airport < ActiveRecord::Base
  has_many :flights
  belongs_to :airline
end
