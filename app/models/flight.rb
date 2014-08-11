class Flight < ActiveRecord::Base
  belongs_to :user
  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'
  has_one :airline, through: :departure_airport

  has_many :prices, dependent: :destroy

  scope :with_name, -> (name) { where('lower(name) ILIKE ?', name.downcase) }
  scope :with_full_name, -> (name) { where('lower(full_name) ILIKE ?', name.downcase) }

end
