Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  # Auth
  get '/sign_in', to: 'auth#sign_in_get'
  get '/sign_up', to: 'auth#sign_up_get'
  post '/sign_out', to: 'auth#sign_up_post'
  post '/sign_in_post', to: 'auth#sign_in_post'
  post '/sign_up_post', to: 'auth#sign_up_post'

  # Dash paths
  get '/dash', to: 'dash#root'
  get '/dash/account/:account_id', to: 'dash#account'
  
  # Admin dash paths
  get '/admin_dash', to: 'admin_dash#root'
  get '/admin_dash/user/:user_id', to: 'admin_dash#user'
  get '/admin_dash/account/:account_id', to: 'admin_dash#account'

  # Admin dash create paths
  get '/admin_dash/create/user', to: 'admin_dash#create_user'
  get '/admin_dash/create/account/:user_id', to: 'admin_dash#create_account'
  get '/admin_dash/create/transaction/:account_id', to: 'admin_dash#create_transaction'
end
