require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe 'POST /auth/register' do
    context 'when user submits valid credentials' do
      it 'registers the user' do
        post api_v1_register_url, params: { 
          user: {
            phone: 'some phone number'
          }
        }
        expect(response).to have_http_status(201)
      end
    end
  end
end
