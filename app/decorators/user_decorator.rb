class UserDecorator < Draper::Decorator
  delegate_all

  def unread_notifications
    count = notifications.unread.count
    text = count == 0 ? 'No unread notifications' : "Unread notifications: #{count}"
    h.link_to text, h.notifications_path
  end
end
