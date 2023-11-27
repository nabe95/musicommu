class Admin::PostCommentsController < ApplicationController
  def index
    @post_comments = PostComment.all.includes(:post).order(created_at: :desc).page(params[:page]).per(8)
    @users = User.all
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    redirect_to admin_post_comments_path
  end
end
