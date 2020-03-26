class FriendshipsController < ApplicationController
  def create
    @rqstuser = User.find(params[:rqstuser_id])
    if current_user.friendships.build(user_id: current_user.id, rqstuser_id: @rqstuser.id).save
      redirect_to user_path(@rqstuser), notice: 'Friend request sent'
    else
      redirect_to current_user, alert: 'Friend Request NOT SENT'
    end
  end

  def index
    @friendships = current_user.friendships
    @friend_requests = current_user.inverse_friendships
  end

  def confirm
    Friendship.confirm_friend(params[:id])
    redirect_back(fallback_location: root_path, notice: 'Now you are friends')
  end

  def destroy
    if params[:id].nil?
      Friendship.destroy_friendship(params[:user_id], params[:rqstuser_id])
    else
      Friendship.destroy_request(params[:id])
    end
    redirect_back(fallback_location: root_path, alert: 'Friend request declined or Frienship finished')
  end
end
