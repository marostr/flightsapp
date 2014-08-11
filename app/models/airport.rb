class Airport < ActiveRecord::Base
  has_many :flights
  belongs_to :airline
  has_and_belongs_to_many :connected_airports, -> { uniq },
                          class_name: 'Airport',
                          join_table: 'airports_connections',
                          foreign_key: 'airport_id',
                          association_foreign_key: 'connected_airport_id'
  validates_associated :connected_airports
end
