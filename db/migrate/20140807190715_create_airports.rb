class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.references :airline
      t.string :name
      t.string :full_name

      t.timestamps
    end
  end
end
