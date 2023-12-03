class Public::PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
    else
      flash[:error] = "コメントを入力してください。"
    redirect_back fallback_location: @post
    end
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
    @post = Post.find(params[:post_id])
  end
  
  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
end
