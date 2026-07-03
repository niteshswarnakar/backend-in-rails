class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?
    decoded = JwtToken.decode(token)
    @current_user = User.find_by(id: decoded&.dig(:user_id))
    render json: { errors: [ "Unauthorized" ] }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
