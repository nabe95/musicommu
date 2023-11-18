class Public::BandPostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @band_post = BandPost.new
  end

  def create
    @band_post = BandPost.new(band_post_params)
    @band_post.user_id = current_user.id
    if @band_post.save
      redirect_to band_posts_path, notice:"投稿しました"
    else
      render "new"
    end
  end

  def index
    @user = current_user
    # ログインユーザーが作成した投稿（公開・非公開を問わず）を取得
    user_posts = @user.band_posts
    # 他のユーザーが作成した公開された投稿を取得と
    public_posts = BandPost.where(status: :public).where.not(user: @user)
    # ユーザーが作成した投稿と他のユーザーが作成した公開投稿を結合
    @band_posts = user_posts.or(public_posts).joins(:user)
                  .where(users: { is_active: true }) #退会したユーザーの投稿を表示させない
                  .order(created_at: :desc) #新規投稿順
                  .page(params[:page]).per(6) #ページネーション
  end

  def show
    @band_post = BandPost.find(params[:id])
    @band_comment = BandComment.new
    if @band_post.status_private? && @band_post.user != current_user
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'このページにはアクセスできません' }
      end
    end
  end

  def edit
    @band_post = BandPost.find(params[:id])
  end

  def update
    @band_post = BandPost.find(params[:id])
    if @band_post.update(band_post_params)
      redirect_to band_post_path(@band_post.id), notice:"投稿しました"
    else
      render "edit"
    end
  end

  def destroy
    @band_post = BandPost.find(params[:id])
    @band_post.destroy
    redirect_to band_posts_path
  end

  private

  def band_post_params
    params.require(:band_post).permit(
      :title, :body, :area, :instrument, :genre, :activity, :direction, :band_type, :status)
  end

  def set_post
      @band_post = BandPost.find(params[:id])
  end

end
