module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    before_action :login_required!
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
    encoded_token = get_token_from_header
    token = decode_token(encoded_token)
    @user = token[0]
  rescue JWT::VerificationError, JWT::IncorrectAlgorithm, JWT::DecodeError
    render_response({}, :unauthorized, message: 'Unauthenticated')
  end

  def decode_token(token)
    jwt_config = Rails.configuration.jwt
    hmac_secret = jwt_config[:hmac_secret]
    JWT.decode(token, hmac_secret, true, { algorithm: 'HS256'})
  end

  def get_token_from_header
    header = request.headers['Authorization']
    return nil unless header
    header.split(' ').last
  end
end
