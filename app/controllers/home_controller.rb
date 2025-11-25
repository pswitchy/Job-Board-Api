class HomeController < ApplicationController
  # We don't need auth for the homepage
  skip_before_action :authorize_request, only: [:index]

  def index
    render json: { 
      message: "Job Board API is running!", 
      status: "online",
      documentation: "/api/v1/jobs"
    }
  end
end