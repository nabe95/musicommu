class Public::SearchesController < ApplicationController
  #投稿の検索機能
  def search
    @content = params[:content]
    @records = @records = Post.search_for(@content, params[:method])
                              .order(created_at: :desc)
                              .page(params[:page]).per(8)
  end

end
