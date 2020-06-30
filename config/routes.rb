Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      
      post 'signup/unique', to: 'signup#check_uniqueness'  
      post 'login', to: 'login#create'
      delete 'signout', to: 'loging#destroy'
      put 'refresh', to: 'login#refresh'
      get 'get_user_by_token', to: 'login#get_user_by_token'
      post 'signup', to: 'signup#create'
    end
  end
end
