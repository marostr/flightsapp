class RenameFieldsInFlight < ActiveRecord::Migration
  def change
    rename_column :flights, :arrival_airport_id, :destination_airport_id
  end
end
