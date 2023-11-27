class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  before_action :ensure_guest_user, only: [:edit]

  def index
    #退会したユーザーは表示させない
    @users = User.where(is_active: true)
                  .page(params[:page]).per(8)
                  .order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
    @following_users = @user.following_users
    @follower_users = @user.follower_users
  end

  def edit
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update
    is_matching_login_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice:"変更しました"
    else
      render "edit"
    end
  end

  # いいね一覧表示
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  #ユーザーが投稿したバンド募集一覧
  def bands
    @user = User.find(params[:id])
    if current_user == @user
      # ログインしているユーザーが対象のユーザーのバンド募集一覧を表示
      @band_posts = @user.band_posts.order(created_at: :desc)
                                    .page(params[:page]).per(6)
    else
      # 非ログインユーザーまたは他のユーザーの場合、公開状態のバンド募集のみ表示
      @band_posts = @user.band_posts.where(status: :public)
                                    .order(created_at: :desc)
                                    .page(params[:page]).per(6)
    end
  end
  
  #ユーザーが参加しているグループ
  def groups
    @user = User.find(params[:id])
    @groups = @user.group_users.map(&:group)
  end

  # 論理的削除、退会処理
  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を行いました。"
    redirect_to root_path
  end
  
  #フォロー一覧
  def follows
    user = User.find(params[:id])
    @users = user.following_users.page(params[:page]).per(10)
  end
  
  #フォロワー一覧
  def followers
    user = User.find(params[:id])
    @users = user.follower_users.page(params[:page]).per(10)
  end

  private

  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction, :age, :prefecture, :genre, :artist, :is_active)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
  
  #他のユーザーがアクセスできないようにする
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
