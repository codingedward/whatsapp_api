module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    before_action: login_required!
  end

  private

  def login_required!
  end
end
