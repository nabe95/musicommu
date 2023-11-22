class Admin::BandCommentsController < ApplicationController
  def index
    @band_comments = BandComment.all.includes(:band_post).order(created_at: :desc).page(params[:page]).per(10)
    @users = User.all
  end

  def destroy
    @band_comment = BandComment.find(params[:id])
    @band_comment.destroy
    redirect_to admin_band_comments_path
  end
end
