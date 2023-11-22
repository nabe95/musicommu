Rails.application.routes.draw do
  #ユーザー用
  # URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
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
        get :check
        patch 'withdraw'
        get :bands
        get :groups
      end
    end
    
    #投稿機能
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      #タグ一覧
      #showアクションが呼び出されてしまうためon: :collectionによりidに基づかない
      get :tags, on: :collection
    end
    
    #グループ機能
    resources :groups, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource :group_users, only: [:create, :destroy]
      #グループチャット
      resources :messages, only: [:create]
    end

    
  end

  #管理者ルーティング
  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :post_comments, only: [:index, :destroy]
    resources :band_comments, only: [:index, :destroy]
  end
  
  #ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
