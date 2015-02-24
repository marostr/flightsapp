class NotificationsController < ApplicationController
  expose(:notifications) { current_user.notifications }
  expose(:notification)
  expose_decorated(:flight) { notification.flight }

  def show
    notification.update_attribute(:read, true)
  end
end
