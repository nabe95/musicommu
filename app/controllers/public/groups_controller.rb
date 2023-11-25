class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :authorize_group_member, only: [:show]

  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(8)
    @user = User.find(current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @messages = @group.messages
    @message = Message.new
    #Roomで相手の名前表示するために記述
    @my_user_id = current_user.id
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    #グループを作成した人を最初からグループメンバーに
    @group.users << current_user
    if @group.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
  
  #グループメンバーか確認
  def authorize_group_member
    @group = Group.find(params[:id])
    unless current_user && @group.users.include?(current_user)
      redirect_to request.referer, notice:"メンバー以外はアクセスできません。グループに参加してください。"
    end
  end
end
