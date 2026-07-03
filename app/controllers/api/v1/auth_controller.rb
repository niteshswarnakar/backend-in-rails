class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :signin ]

  def signin
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      token = JwtToken.encode(user_id: user.id)
      render json: UserSerializer.new(user, token).as_json, status: :ok
    else
      render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
