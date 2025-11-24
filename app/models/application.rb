class Application < ApplicationRecord
  belongs_to :job
  belongs_to :user

  # Note the colon :status and the comma
  enum :status, { applied: 0, reviewed: 1, interview: 2, rejected: 3, hired: 4 }

  after_create_commit :notify_employer

  private

  def notify_employer
    NotificationsChannel.broadcast_to(
      job.company.user,
      { title: "New Applicant", body: "#{user.email} applied for #{job.title}" }
    ) rescue nil
    
    ApplicationNotificationJob.perform_later(self.id)
  end
end