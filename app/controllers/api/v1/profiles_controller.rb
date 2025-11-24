module Api
  module V1
    class ProfilesController < ApplicationController
      # GET /profiles/me (Get current user's profile)
      def show
        # If looking for a specific ID, use find, otherwise show current user's profile
        profile = if params[:id]
                    Profile.find(params[:id])
                  else
                    current_user.profile
                  end
        
        if profile
          # Generate a URL for the resume if it exists
          resume_url = profile.resume.attached? ? rails_blob_url(profile.resume) : nil
          
          render json: profile.as_json.merge(resume_url: resume_url)
        else
          render json: { error: 'Profile not found' }, status: :not_found
        end
      end

      # POST /profiles
      def create
        return head :forbidden unless current_user.seeker?

        if current_user.profile.present?
          render json: { error: 'Profile already exists' }, status: :conflict
          return
        end

        profile = current_user.build_profile(profile_params)

        if profile.save
          render json: profile, status: :created
        else
          render json: profile.errors, status: :unprocessable_entity
        end
      end

      # PATCH /profiles/:id
      def update
        profile = current_user.profile

        if profile.nil?
          render json: { error: 'Profile not found' }, status: :not_found
          return
        end

        if profile.update(profile_params)
          render json: profile
        else
          render json: profile.errors, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        # :resume comes in as a file upload from the frontend (multipart/form-data)
        params.permit(:full_name, :bio, :skills, :resume)
      end
    end
  end
end