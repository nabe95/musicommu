class Public::UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice:"変更しました"
    else
      render"edit"
    end
  end
  
  # いいね一覧表示
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction, :age, :prefecture, :genre, :artist)
  end
  
end
