class Application < ApplicationRecord
  belongs_to :job
  belongs_to :user

  enum status: { applied: 0, reviewed: 1, interview: 2, rejected: 3, hired: 4 }

  # Trigger notification after creation
  after_create_commit :notify_employer

  private

  def notify_employer
    # 1. Send Real-time via ActionCable
    NotificationsChannel.broadcast_to(
      job.company.user,
      { title: "New Applicant", body: "#{user.email} applied for #{job.title}" }
    )
    
    # 2. Send Email (Background Job)
    # UserNotificationJob.perform_later(self.id)
  end
end