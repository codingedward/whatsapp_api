module AuthSpecHelper
  def stub_user(user = nil)
    user ||= FactoryBot.create(:user)
    allow(JWT).to receive(:decode).and_return([user.as_json])
  end
end
