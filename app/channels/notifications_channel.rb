class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # Stream for the specific logged-in user
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end