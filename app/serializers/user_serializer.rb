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
          first_name: @user.first_name,
          name: "#{@user.first_name} #{@user.last_name}",
          country: @user.country,
          created_at: @user.created_at,
          updated_at: @user.updated_at
        }
      }
    }
  end
end
