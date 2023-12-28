Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#top'
  get '/signup' , to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new' #ログインページ
  post   '/login', to: 'sessions#create' # ログイン 
  delete '/logout', to: 'sessions#destroy' # ログアウト
  
  resources :users do
    collection do
      get 'edit_basic_info' # 勤怠情報編集ページ
      patch '/update_all_users_info', to: 'users#update_all_users_info', as: 'update_all_users_info'
    end
    member do
      get 'attendances/edit_one_month' # 勤怠編集ページ
      patch 'attendances/update_one_month' # 勤怠編集データ更新
    end
    resources :attendances, only: :update # viewsなし。updateアクションのみ
  end
  
end