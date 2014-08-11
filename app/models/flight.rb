class Flight < ActiveRecord::Base
  belongs_to :user
  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'
  has_one :airline, through: :departure_airport

  has_many :prices, dependent: :destroy

end
