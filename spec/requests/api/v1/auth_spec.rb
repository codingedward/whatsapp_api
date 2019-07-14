require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe 'POST /auth/register' do

    context 'when user submits invalid credentials' do
      it 'returns validation error' do
        post api_v1_register_url, params: {
          user: attributes_for(:user, phone: nil) 
        }
        expect(response).to have_http_status(:unprocessable_entity)

        post api_v1_register_url, params: {
          user: attributes_for(:user, name: nil)
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user submits valid credentials' do
      before(:all) do
        post api_v1_register_url, params: {
          user: attributes_for(:user) 
        }
      end

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a token' do
        expect(json_response[:token]).not_to be_nil
      end

      it 'registers the user' do
        expect(json_response[:message]).to include('registered')
      end
    end
  end
end
