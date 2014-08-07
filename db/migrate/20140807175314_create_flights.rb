class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.references :user
      t.references :departure_airport
      t.references :arrival_airport

      t.datetime :departure_date
      t.datetime :arrival_date

      t.timestamps
    end
  end
end
