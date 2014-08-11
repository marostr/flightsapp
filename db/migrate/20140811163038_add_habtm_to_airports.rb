class AddHabtmToAirports < ActiveRecord::Migration
  def change
    create_table :airports_connections, id: false do |t|
      t.integer :airport_id
      t.integer :connected_airport_id
    end
  end
end
