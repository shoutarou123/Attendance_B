Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#top'
  get '/signup' , to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new' #ログインページ
  post   '/login', to: 'sessions#create' # ログイン 
  delete '/logout', to: 'sessions#destroy' # ログアウト
  
  resources :users do
    member do
      get 'edit_basic_info' # 勤怠情報編集ページ
      patch 'update_basic_info' # 勤怠情報更新アクション
      get 'attendances/edit_one_month' # 勤怠編集ページ
    end
    resources :attendances, only: :update # viewsなし。updateアクションのみ
  end
end