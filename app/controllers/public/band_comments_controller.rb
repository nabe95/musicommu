class Public::BandCommentsController < ApplicationController
  def create
    @band_post = BandPost.find(params[:band_post_id])
    @comment = current_user.band_comments.new(band_comment_params)
    @comment.band_post_id = @band_post.id
    @comment.save
    #直前のページにリダイレクト
    redirect_to request.referer
  end
  
  def destroy
    @comment = BandComment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end
  
  private
    def band_comment_params
      params.require(:band_comment).permit(:comment)
    end

end
