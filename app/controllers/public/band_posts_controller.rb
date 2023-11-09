class Public::BandPostsController < ApplicationController
  def new
    @band_post = BandPost.new
  end
  
  def create
    @band_post = BandPost.find(params[:id])
    @band_post.update(post_params)
    redirect_to post_path(@band_post.id)
  end

  def index
    @band_posts = BandPost.all
    @user = current_user
  end

  def show
    @band_post = BandPost.find(params[:id])
  end

  def edit
    @band_post = BandPost.find(params[:id])
  end
  
  def update
    @band_post = BandPost.find(params[:id])
    @band_post.update(band_post_params)
    redirect_to band_post_path(@band_post.id)
  end
  
  def destroy
    @band_post = BandPost.find(params[:id])
    @band_post.destroy
    redirect_to band_posts_path
  end
  
  private
  
  def band_post_params
    params.require(:band_post).permit(:title, :body)
  end
  
end
