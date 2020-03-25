class FriendshipsController < ApplicationController
  def create
    @rqstuser = User.find(params[:rqstuser])
    if current_user.friendships.build(rqstuser_id: @rqstuser.id).save
      redirect_to user_path(@rqstuser), notice: 'Friend request sent'
    else
      redirect_to current_user, notice: 'Friend Request NOT SENT'
    end
  end

  def index
    @friendships = current_user.friendships
    @friend_requests = current_user.inverse_friendships
  end

  def confirm_friendship

  end

  def destroy
    @rqstuser = User.find(params[:id])
    if current_user.friend?(@rqstuser)
      current_user.unfriend(@rqstuser)
      redirect_to @rqstuser, notice: 'You are NOT friends anymore'
    else
      redirect_to @rqstuser, notice: 'Uncaught operation --> contact backend support'
    end
  end
end
