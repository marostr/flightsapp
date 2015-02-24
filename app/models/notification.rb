class Notification < ActiveRecord::Base
  belongs_to :flight

  scope :unread, -> { where(read: false) }
end
