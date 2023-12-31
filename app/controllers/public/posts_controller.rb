class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(',')
    if @post.save
    @post.save_tags(tag_list)
    redirect_to post_path(@post), notice:"投稿しました"
    else
      render "new"
    end
  end

  def index
    #退会したユーザーのを表示させない
    @posts = Post.joins(:user).where(users: { is_active: true })
                  .order(created_at: :desc) #新規投稿順
                  .page(params[:page]).per(6) #ページネーション
    @user = current_user
    @tag_list = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @tag_list = @post.tags.pluck(:name).join(',')
    @post_tags = @post.tags
  end

  def edit
    is_matching_login_user
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    is_matching_login_user
    @post = Post.find(params[:id])
    tag_list=params[:post][:name].split(',')
    if @post.update(post_params)
    @post.save_tags(tag_list)
    redirect_to post_path(@post.id), notice:"変更しました"
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  # タグ検索
  def search_tag
    @tag_list = Tag.all
    #検索されたタグの受け取り
    @tag = Tag.find(params[:tag_id])
    #検索されたタグのついた投稿を表示
    @posts = @tag.posts.order(created_at: :desc)
                      .page(params[:page]).per(8)
  end

# タグ一覧
  def tags
  @tag_list = Tag.all
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, tags: [:name])
  end

  #他のユーザーがアクセスできないようにする
  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end

end
