module FriendshipsHelper
    def friend_unfriend_btn
        @viewed_user = User.find(params[:id])
        unless current_user.friend?(@viewed_user)
            link_to('Send friend request', user_friendship_path(user: current_user, rqstuser: @viewed_user), method: :delete)
        else
            link_to('Cancel frienship', user_friendship_path(user: current_user, rqstuser: @viewed_user), method: :delete)
        end
    end
end
