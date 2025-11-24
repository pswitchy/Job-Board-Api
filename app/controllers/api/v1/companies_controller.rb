module Api
  module V1
    class CompaniesController < ApplicationController
      skip_before_action :authorize_request, only: [:show, :index]

      # GET /companies
      def index
        companies = Company.all
        render json: companies
      end

      # GET /companies/:id
      def show
        company = Company.find(params[:id])
        render json: company, include: :jobs
      end

      # POST /companies
      def create
        # Only Employers can create companies
        return head :forbidden unless current_user.employer?
        
        # Check if user already has a company
        if current_user.company.present?
          render json: { error: 'User already has a company' }, status: :conflict
          return
        end

        company = current_user.build_company(company_params)
        
        if company.save
          render json: company, status: :created
        else
          render json: company.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /companies/:id
      def update
        company = Company.find(params[:id])

        # Ensure the logged-in user owns this company
        if company.user_id == current_user.id
          if company.update(company_params)
            render json: company
          else
            render json: company.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      private

      def company_params
        params.permit(:name, :description, :website, :location)
      end
    end
  end
end