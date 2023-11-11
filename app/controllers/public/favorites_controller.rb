class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @favorite.save
    #非同期通信:js.erbファイルへ
    render 'replace_favorite'
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @favorite.destroy
    #非同期通信:js.erbファイルへ
    render 'replace_favorite'
  end
end
