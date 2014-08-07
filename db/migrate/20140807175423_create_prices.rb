class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :flight
      t.decimal :normal, precision: 8, scale: 2
      t.decimal :discount, precision: 8, scale: 2
      t.string :currency
      t.timestamps
    end
  end
end
