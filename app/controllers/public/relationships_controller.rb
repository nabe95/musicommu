class Public::RelationshipsController < ApplicationController
  #フォローする
  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    #非同期通信:js.erbファイルへ
    render 'replace_relationship'
  end

  #フォローを外す
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
    #非同期通信:js.erbファイルへ
    render 'replace_relationship'
  end
end
