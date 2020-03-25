class FriendshipsController < ApplicationController

  def create
    @rqstuser = User.find(params[:id])

    if current_user.friendship.build(rqstuser_id: @rqstuser.id).save
      flash.now[:success] = 'Friend request sent'
      render @rqstuser
    else
      flash.now[:success] = 'Friend request NOT sent'
      render current_user
    end
  end

  def index
    @friendships = current_user.friendships
  end

  def destroy
    @rqstuser = User.find(params[:id])
    if current_user.friend?(@rqstuser)
      current_user.unfriend(@rqstuser)
      flash.now[:success] = 'You are not friends anymore'
      redirect_to @rqstuser
    end
  end
end
