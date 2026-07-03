class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      token = JwtToken.encode(user_id: user.id)
      render json: UserSerializer.new(user, token).as_json, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    {
      first_name: params[:firstName],
      last_name: params[:lastName],
      email: params[:email],
      password: params[:password],
      country: params[:country]
    }
  end
end
