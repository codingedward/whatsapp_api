module Api
  module V1
    class AuthController < ApplicationController
      include AuthenticationConcern
      skip_before_action :login_required!, only: %i[register login]

      def register
        user = User.create(register_params)
        if user.valid?
          render_created({
                           user: user,
                           token: create_token(user)
                         }, message: "Successfully registered user")
        else
          render_unproccessable(user)
        end
      end

      def login
        # TODO: use sms service to send verification code to the user
        user = User.find_by(phone: login_params[:phone])
        if user.nil?
          render_unproccessable(message: "Invalid credentials")
        else
          render_ok({
                      user: user,
                      token: create_token(user)
                    }, message: "Successfully logged in")
        end
      end

      def get_info
        render_ok(@auth_user, message: "Successfully retrieved info")
      end

      def logout
        JwtBlacklist.create(token: @auth_token)
        render_ok(message: "Successfully logged out")
      end

      def refresh_token
        render_ok({ token: create_token(@auth_user) },
                  message: "Successfully refreshed token")
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
