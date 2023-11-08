class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
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
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction, :age, :prefectures)
  end
  
end
