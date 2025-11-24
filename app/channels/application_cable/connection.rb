module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # 1. Try to get token from URL params (ws://url?token=...)
      # 2. Or try to get it from headers (if your client supports it)
      token = request.params[:token] || request.headers['Authorization']&.split(' ')&.last

      decoded = JwtService.decode(token)

      if decoded && (user = User.find_by(id: decoded[:user_id]))
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end