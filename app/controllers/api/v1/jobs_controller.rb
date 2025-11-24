module Api
  module V1
    class JobsController < ApplicationController
      skip_before_action :authorize_request, only: [:index, :show]

      # GET /jobs (Search enabled)
      def index
        query = params[:q].presence || "*"
        
        # Filters
        conditions = {}
        conditions[:location] = params[:location] if params[:location].present?
        conditions[:salary_min] = { gte: params[:min_salary] } if params[:min_salary].present?
        
        jobs = Job.search(query, where: conditions, page: params[:page], per_page: 10)
        
        render json: {
          jobs: jobs.results,
          total: jobs.total_count,
          page: params[:page] || 1
        }
      end

      # GET /jobs/:id
      def show
        @job = Job.find(params[:id])
        # Simple Analytics: Increment view count
        @job.increment!(:views) 
        render json: @job, include: :company
      end

      # POST /jobs (Employers only)
      def create
        return head :forbidden unless current_user.employer?

        @job = current_user.company.jobs.build(job_params)
        if @job.save
          render json: @job, status: :created
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      private

      def job_params
        params.permit(:title, :description, :location, :salary_min, :salary_max, :job_type)
      end
    end
  end
end