module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    before_action :login_required!
    before_action :set_user_from_token!
  end

  def create_token(user)
    jwt_config = Rails.configuration.jwt
    hmac_secret = jwt_config[:hmac_secret]
    valid_until = jwt_config[:valid_duration].from_now
    payload = { name: user.name, phone: user.phone, exp: valid_until.to_i}
    JWT.encode(payload, hmac_secret, 'HS256')
  end

  private

  def login_required!
  end

  def set_user_from_token!
  end
end
