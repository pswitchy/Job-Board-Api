class Application < ApplicationRecord
  belongs_to :job
  belongs_to :user

  enum status: { applied: 0, reviewed: 1, interview: 2, rejected: 3, hired: 4 }

  after_create_commit :notify_employer

  private

  def notify_employer
    # 1. Real-time Notification (WebSockets)
    # We use '&' (safe navigation) in case the notification channel isn't set up yet
    NotificationsChannel.broadcast_to(
      job.company.user,
      { title: "New Applicant", body: "#{user.email} applied for #{job.title}" }
    ) rescue nil
    
    # 2. Email Notification (Background Job)
    # This matches the class name we defined in Step 1
    ApplicationNotificationJob.perform_later(self.id)
  end
end