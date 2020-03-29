module FriendshipsHelper
  def friend_btn_show(id = nil)
    params[:index_id] = id if id
    @viewed_user = User.find(params[:index_id] ||= params[:id])

    if current_user.pending_friend?(@viewed_user)
      link_to 'Confirm Friend Request', friendships_path
    elsif @viewed_user.pending_friend?(current_user)
      link_to('Friend request waiting for acceptance. Decline request',
              unfriend_path(user_id: current_user, rqstuser_id: params[:index_id] ||= params[:id]),
              method: :delete)
    elsif !current_user.pending_friend?(@viewed_user)
      friend_unfriend_btn
    end
  end

  def friend_unfriend_btn
    if current_user.friend?(@viewed_user)
      link_to('Cancel friendship', unfriend_path(user_id: current_user,
                                                 rqstuser_id: params[:index_id] ||= params[:id]),
              method: :delete)
    else
      link_to('Send friend request', user_friendships_path(user_id: current_user,
                                                           rqstuser_id: params[:index_id] ||= params[:id]),
              method: :post)
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
