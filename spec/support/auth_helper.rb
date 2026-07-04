module AuthHelper
  # Builds an Authorization header that authenticate_request will accept
  # for the given user, e.g.:
  #
  #   get "/api/v1/contents", headers: auth_headers(user)
  #
  def auth_headers(user)
    token = JwtToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
