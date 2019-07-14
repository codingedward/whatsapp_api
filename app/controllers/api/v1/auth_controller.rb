require 'jwt'

module Api
  module V1
    class AuthController < ApplicationController
      include AuthenticationConcern
      def register
        user = User.create(register_params)

        render json: {
          message: 'Successfully registered',
          token: create_token(user),
          user: user,
        }, status: :created
      end
      
      def login
        # TODO: use sms service to send a token to the user
        user = User.find_by(phone: login_params[:phone])

        render json: { 
          message: 'Successfully logged in',
          token: create_token(user),
          user: user,
        }, status: :ok
      end

      def logout
      end

      def refresh_token
      end

      private

      def register_params
        params.require(:user).permit(
          :name,
          :phone,
          :status,
          :photo_id,
        )
      end

      def login_params
        params.require(:phone)
      end
    end
  end
end
