class Public::MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if GroupUser.where(:user_id => current_user.id, :group_id => params[:message][:group_id]).present?
      @message = Message.create(params.require(:message).permit(:message,:user_id, :content, :group_id).merge(:user_id => current_user.id))
      redirect_to "/groups/#{@message.group_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
