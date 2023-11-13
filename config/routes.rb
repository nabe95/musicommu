Rails.application.routes.draw do
  #ユーザー用
  # URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwwords], controllers: {
    sessions: "admin/sessions"
  }

  #ユーザールーティング
  scope module: :public do
    root to: 'homes#top'
    
    #キーワード検索
    get "search", to: "searches#search"
    
    #タグ検索
    get "search_tag" => "posts#search_tag"
    
    # バンド募集
    resources :band_posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :band_comments, only: [:create, :destroy]
    end
    
    # ユーザー
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get :favorites 
      end
    end
    
    #投稿機能
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
  end

  #管理者ルーティング
  namespace :admin do
    get '/' => 'homes#top'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
