Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#top'
  get '/signup' , to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new' #ログインページ
  post   '/login', to: 'sessions#create' # ログイン 
  delete '/logout', to: 'sessions#destroy' # ログアウト
  
  resources :users
end