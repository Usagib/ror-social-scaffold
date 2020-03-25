class FriendshipsController < ApplicationController

  def create
    @friendship = Friendship.new(user_id: current_user.id)
    @friendship.rqstuser_id = params[:user_id]

    if @friendship.save
      flash.now[:success] = 'Request sentt'
      redirect_to current_user
    else
      render 'new'
    end
  end

  def index
    @friendships = current_user.friendships
    @inverse_friendships = current_user.inverse_friendships
  end

  def update
  end

  def destroy
    @friendship = Friendship.find_by(user_id: current_user.id, rqstuser_id: params[:user_id])
    if @friendship.destroy
      flash.now[:success] = 'You are not friends anymore'
      redirect_to current_user
    else
      render 'new'
    end
  end
end
