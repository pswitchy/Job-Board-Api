class ApplicationController < ActionController::API
    include Rails.application.routes.url_helpers
    before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JwtService.decode(header)
    
    if decoded
      @current_user = User.find(decoded[:user_id])
    else
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end