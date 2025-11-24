class ApplicationNotificationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = Application.find_by(id: application_id)
    return unless application

    # Send the email
    NotificationMailer.new_application_email(application).deliver_now
  rescue StandardError => e
    Rails.logger.error "Failed to send notification: #{e.message}"
  end
end