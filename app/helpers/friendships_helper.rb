module FriendshipsHelper
  def friend_btn_show
    @viewed_user = User.find(params[:id])
    if current_user.friend_requests.include?(@viewed_user)
      link_to 'Confirm Friend Request', friendships_path
    elsif !current_user.pending_friend?(@viewed_user) && !current_user.eql?(@viewed_user)
      friend_unfriend_btn
    elsif !current_user.eql?(@viewed_user)
      link_to('Friend request waiting for acceptance. Decline request',
              unfriend_path(user_id: current_user, rqstuser_id: params[:id]), method: :delete)
    end
  end

  def friend_unfriend_btn
    if current_user.friend?(@viewed_user)
      link_to('Cancel friendship', unfriend_path(user_id: current_user, rqstuser_id: params[:id]), method: :delete)
    else
      link_to('Send friend request', user_friendships_path(user_id: current_user,
                                                           rqstuser_id: params[:id]), method: :post)
    end
  end

  def confirm_btn(frn)
    link_to('Confirm Friendship Request',
            confirm_path(id: frn.id, iduser_id: frn.user_id, rqstuser: frn.rqstuser_id), method: :patch)
  end

  def decline_btn(frn)
    link_to('Decline Friendship Request',
            unfriend_path(id: frn.id, user_id: frn.user_id, rqstuser_id: frn.rqstuser_id), method: :delete)
  end
end
