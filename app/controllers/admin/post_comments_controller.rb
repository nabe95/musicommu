class Admin::PostCommentsController < ApplicationController
  def index
    @post_comments = PostComment.all.includes(:post)
    @users = User.all
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    redirect_to admin_post_comments_path
  end
end
