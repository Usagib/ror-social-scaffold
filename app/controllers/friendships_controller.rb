class FriendshipsController < ApplicationController
  def create
    @rqstuser = User.find(params[:rqstuser_id] ||= params[:index_id])
    if current_user.friendships.build(rqstuser_id: @rqstuser.id).save
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
    friendship = Friendship.find(params[:id])
    friendship.confirm_friend
    redirect_back(fallback_location: root_path, notice: 'Now you are friends')
  end

  def destroy
    if params[:id]
      Friendship.find(params[:id]).destroy
    else
      friendship = Friendship.find_by(user_id: params[:user_id], rqstuser_id: params[:rqstuser_id])
      friendship.destroy_friendship
    end
    redirect_back(fallback_location: root_path, alert: 'Friend request declined or Frienship finished')
  end
end
