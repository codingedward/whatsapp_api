require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /auth/register" do
    context "when user submits incorrect details" do
      it "returns validation error" do
        post api_v1_register_url, params: attributes_for(:user, phone: nil)
        expect(response).to have_http_status(:unprocessable_entity)

        post api_v1_register_url, params: attributes_for(:user, name: nil)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user submits correct details" do
      before(:all) do
        post api_v1_register_url, params: attributes_for(:user)
      end

      it "returns status 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns a token" do
        expect(json_response[:token]).not_to be_nil
      end

      it "registers the user" do
        expect(json_response[:message]).to include("registered")
      end
    end
  end

  describe "POST /auth/login" do
    before(:all) do
      create(:user)
    end

    context "when user submits invalid credentials" do
      it "returns invalid login error" do
        post api_v1_login_url params: { phone: "clearly invalid phone" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:message]).to include("Invalid credentials")
      end
    end

    context "when user submits valid credentials" do
      before(:all) do
        post api_v1_login_url params: { phone: User.first.phone }
      end

      it "returns status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a token" do
        expect(json_response[:token]).not_to be_nil
      end

      context "when user visits protected route with token" do
        it "does not return status 401" do
          get api_v1_info_url, headers: {
            'Authorization': "Bearer #{json_response[:token]}"
          }
          expect(response).not_to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "GET /auth/info" do
    context "when user is not authenticated" do
      before(:all) do
        get api_v1_info_url
      end
      it "returns status 401" do
        expect(response).to have_http_status(:unauthorized)
      end
      it "contains unauthenticated message" do
        expect(json_response[:message]).to include("Unauthenticated")
      end
    end

    context "when user is authenticated" do
      let (:user) { create(:user) }
      before(:each) do
        stub_user(user)
        get api_v1_info_url
      end

      it "returns status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns user information" do
        expect(json_response[:user]).to include(
          id: user.id,
          name: user.name,
          phone: user.phone,
        )
      end
    end
  end

  describe "DELETE /auth/logout" do
    context "when user logs out" do
      context "when user has a valid token" do
        before(:all) do
          create(:user)
          post api_v1_login_url params: { phone: User.first.phone }
        end

        let(:auth_headers) do
          { "Authorization" => "Bearer #{json_response[:token]}" }
        end

        it "logs out the user" do
          delete api_v1_logout_url, headers: auth_headers
          expect(response).to have_http_status(200)

          get api_v1_info_url, headers: auth_headers
          expect(response).to have_http_status(401)
          expect(json_response[:message]).to include("Unauthenticated")
        end
      end

      context "when user does not have a valid token" do
        it "returns status 401" do
          delete api_v1_logout_url
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
