Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users
  root 'pages#home'

  # Auth
  get '/sign_in', to: 'auth#sign_in_get'
  get '/sign_up', to: 'auth#sign_up_get'
  post '/sign_out', to: 'auth#sign_out_post'
  post '/sign_in_post', to: 'auth#sign_in_post'
  post '/sign_up_post', to: 'auth#sign_up_post'

  # Dash paths
  get '/dash', to: 'dash#root'
  get '/dash/account/:account_id', to: 'dash#account'

  # Admin dash paths
  get '/admin_dash', to: 'admin_dash#root'
  get '/admin_dash/user/:user_id', to: 'admin_dash#user'
  get '/admin_dash/account/:account_id', to: 'admin_dash#account'
  get '/admin_dash/look_and_feel', to: 'admin_dash#look_and_feel'

  # Admin dash create, edit and delete paths
  post '/admin_dash/create/user_post', to: 'admin_dash#create_user_post'
  post '/admin_dash/create/account_post/:user_id', to: 'admin_dash#create_account_post'
  post '/admin_dash/create/transaction_post/:account_id', to: 'admin_dash#create_transaction_post'
  post '/admin_dash/account/:account_id', to: 'admin_dash#generate_transaction'

  get '/admin_dash/create/user', to: 'admin_dash#create_user'
  get '/admin_dash/create/account/:user_id', to: 'admin_dash#create_account'
  get '/admin_dash/create/transaction/:account_id', to: 'admin_dash#create_transaction'


  get '/admin_dash/edit/transaction/:transaction_id', to: 'admin_dash#edit_transaction'
  get '/admin_dash/edit/account/:account_id', to: 'admin_dash#edit_account'
  get '/admin_dash/edit/user/:user_id', to: 'admin_dash#edit_user'

  delete '/admin_dash/delete/transaction/:transaction_id', to: 'admin_dash#delete_transaction'
  delete '/admin_dash/delete/account/:account_id', to: 'admin_dash#delete_account'
  delete '/admin_dash/delete/user/:user_id', to: 'admin_dash#delete_user'

  post '/admin_dash/edit/transaction_post/:transaction_id', to: 'admin_dash#edit_transaction_post'
  post '/admin_dash/edit/account_post/:account_id', to: 'admin_dash#edit_account_post'
  post '/admin_dash/edit/user_post/:user_id', to: 'admin_dash#edit_user_post'
  post '/admin_dash/edit/look_and_feel', to: 'admin_dash#look_and_feel_post'
end
