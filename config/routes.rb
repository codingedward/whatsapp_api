Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do
      scope 'auth' do
        post 'register', to: 'auth#register'
        post 'login', to: 'auth#login'
        delete 'logout', to: 'auth#logout'
        put 'refresh', to: 'auth#refresh_token'
      end
    end
  end
end
