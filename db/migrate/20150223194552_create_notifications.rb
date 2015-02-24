class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :body
      t.boolean :read, default: false
      t.belongs_to :flight
    end
  end
end
