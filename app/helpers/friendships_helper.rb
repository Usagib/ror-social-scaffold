module FriendshipsHelper

    def friend_btn_show
        @viewed_user = User.find(params[:id])
        if !current_user.pending_friend?(@viewed_user)
            friend_unfriend_btn
        else
            link_to("Friend request waiting for acceptance", user_path(current_user))
        end
    end


    def friend_unfriend_btn
        unless current_user.friend?(@viewed_user)
            link_to('Send friend request', user_friendships_path(user_id: current_user, rqstuser: @viewed_user), method: :post)
        else
            link_to('Cancel frienship', user_friendship_path(user: current_user, rqstuser: @viewed_user), method: :delete)
        end
    end
end
