class Public::SearchesController < ApplicationController
  #投稿の検索機能
  def search
    @content = params[:content]
    @records = @records = Post.search_for(@content, params[:method])
  end

end
