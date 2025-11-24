module Api
  module V1
    class ApplicationsController < ApplicationController
      
      # POST /jobs/:job_id/apply
      def create
        return head :forbidden unless current_user.seeker?

        job = Job.find(params[:job_id])
        application = Application.new(job: job, user: current_user, status: :applied)
        
        # If user has a profile resume, it's auto-linked logic would go here
        # Or allow specific resume upload for this application
        
        if application.save
          render json: { message: "Applied successfully" }, status: :created
        else
          render json: application.errors, status: :unprocessable_entity
        end
      end

      # GET /applications (For Employer Dashboard)
      def index_employer
        return head :forbidden unless current_user.employer?
        # Get all applications for all jobs posted by this company
        apps = Application.joins(:job).where(jobs: { company_id: current_user.company.id })
        render json: apps, include: [:user, :job]
      end
      
      # PATCH /applications/:id (Update Status)
      def update_status
         return head :forbidden unless current_user.employer?
         
         app = Application.find(params[:id])
         # Ensure employer owns the job
         if app.job.company.user_id == current_user.id
           app.update(status: params[:status])
           render json: app
         else
           head :unauthorized
         end
      end
    end
  end
end