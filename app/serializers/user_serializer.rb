class UserSerializer
  def initialize(user, token)
    @user = user
    @token = token
  end

  def as_json(*)
    {
      data: {
        id: @user.id,
        type: "users",
        attributes: {
          token: @token,
          email: @user.email,
          name: "#{@user.first_name} #{@user.last_name}",
          country: @user.country,
          createdAt: @user.created_at,
          updatedAt: @user.updated_at
        }
      }
    }
  end
end
