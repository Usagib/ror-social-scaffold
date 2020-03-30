class Friendship < ApplicationRecord
  self.primary_keys = :user_id, :rqstuser_id
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :rqstuser, foreign_key: :rqstuser_id, class_name: 'User'

  # Confirmation and deletion methods for processing requests
  # Confirms friendship
  def confirm_friend
    second_row
    update(status: true)
    Friendship.find(id.reverse).update(status: true)
  end

  # Intances second row in friendships if confirmation occurs
  def second_row
    frd = Friendship.find(id)
    return if Friendship.friendship_exists?(frd.rqstuser_id, frd.user_id)

    Friendship.create(user_id: frd.rqstuser_id, rqstuser_id: frd.user_id)
  end

  # Destroy friendship on friended users
  def destroy_friendship
    friendship = Friendship.where(user_id: user_id, rqstuser_id: rqstuser_id).take
    inverse_friendship = Friendship.where(user_id: rqstuser_id, rqstuser_id: user_id).take
    friendship&.delete
    inverse_friendship&.delete
  end

  class << self
    # Returns existance status for a requested friendship
    def friendship_exists?(user_id, rqstuser_id)
      Friendship.where(user_id: user_id, rqstuser_id: rqstuser_id).exists?
    end
  end
end
