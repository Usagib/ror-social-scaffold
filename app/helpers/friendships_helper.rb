module FriendshipsHelper
  def friend_btn_show
    @viewed_user = User.find(params[:id])
    if !current_user.pending_friend?(@viewed_user)
      friend_unfriend_btn
    else
      link_to('Friend request waiting for acceptance', user_path(current_user))
    end
  end

  def friend_unfriend_btn
    if current_user.friend?(@viewed_user)
      link_to('Cancel frienship', user_friendship_path(user_id: current_user, rqstuser: @viewed_user), method: :delete)
    else
      link_to('Send friend request', user_friendships_path(user_id: current_user,
                                                           rqstuser: @viewed_user), method: :post)
    end
  end

  def confirm_btn
      @requestuser = User.find_by(params[:rqstuser])
      @friendship = current_user.friendships.where(rqstuser_id: @requestuser, user_id: current_user)
      link_to('Confirm Friendship', confirm_path(user_id: current_user, rqstuser: @requestuser), method: :post)
      #link_to('Decline Frienship', user_friendship_path(id: @friendship, user_id: current_user, rqstuser: @requestuser), method: :delete)
  end


end
