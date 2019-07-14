require 'jwt'

module Api
  module V1
    class AuthController < ApplicationController
      include AuthenticationConcern

      def register
        user = User.create(register_params)
        if user.valid?
          render_created({ 
            user: user, 
            token: create_token(user) 
          }, message: 'Successfully registered user')
        else
          render_unproccessable(user)
        end
      end
      
      def login
        # TODO: use sms service to send verification code to the user
        user = User.find_by_phone(login_params[:phone])
        if user.nil?
          render_unproccessable(message: "Invalid credentials")
        else
          render_ok({
            token: create_token(user)
          }, message: 'Successfully logged in')
        end
      end

      def get_info
        render json: {
          message: 'Successfully retrieved info',
          user: @user,
        }, status: :ok
      end

      def logout
      end

      def refresh_token
      end

      private

      def register_params
        params.permit(
          :name,
          :phone,
          :status,
          :photo_id,
        )
      end

      def login_params
        params.permit(:phone)
      end
    end
  end
end
