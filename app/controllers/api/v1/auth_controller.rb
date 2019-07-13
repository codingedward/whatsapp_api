module Api
  module V1
    class AuthController < ApplicationController
      include AuthenticationConcern

      def register
      end
      
      def login
      end

      def logout
      end

      def refresh_token
      end

      private
    end
  end
end
