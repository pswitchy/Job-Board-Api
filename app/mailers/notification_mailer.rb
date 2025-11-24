class NotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def new_application_email(application)
    @application = application
    @job = application.job
    @employer = @job.company.user
    @applicant = application.user
    
    # Check if applicant has a profile, otherwise fallback to email
    @applicant_name = @applicant.profile&.full_name || @applicant.email

    mail(
      to: @employer.email, 
      subject: "New Application for #{@job.title}"
    )
  end
end