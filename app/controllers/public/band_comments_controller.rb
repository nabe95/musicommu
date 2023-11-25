class Public::BandCommentsController < ApplicationController
  def create
    @band_post = BandPost.find(params[:band_post_id])
    @comment = current_user.band_comments.new(band_comment_params)
    @comment.band_post_id = @band_post.id
    if @comment.save
    else
      flash[:notice] = "コメントを入力してください。"
      redirect_back fallback_location: @band_post
    end
  end
  
  def destroy
    @comment = BandComment.find(params[:id])
    @comment.destroy
    @band_post = BandPost.find(params[:band_post_id])
  end
  
  private
    def band_comment_params
      params.require(:band_comment).permit(:comment)
    end

end
