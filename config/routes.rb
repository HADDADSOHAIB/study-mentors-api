Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      post 'signup/unique', to: 'signup#check_uniqueness'  
      post 'signup', to: 'signup#create'

      get 'login/get_user_by_token', to: 'login#get_user_by_token'
      put 'login/refresh', to: 'login#refresh'
      post 'login', to: 'login#create'

      put 'teachers/:id/update_profil', to: 'teachers#update_profile'
      put 'teachers/:id/update_schedule', to: 'teachers#update_schedule'
      put 'teachers/:id/update_session_type', to: 'teachers#update_session_type'

      delete 'signout', to: 'loging#destroy'
    end
  end
end
