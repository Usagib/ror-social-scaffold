class Friendship < ApplicationRecord
  validate :unique_friendship

  self.primary_keys = :user_id, :rqstuser_id
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :rqstuser, foreign_key: :rqstuser_id, class_name: 'User'

  # Confirmation and deletion methods for processing requests
  class << self
    def confirm_friend(fr_id)
      Friendship.second_row(fr_id)
      Friendship.find(fr_id).update(status: true)
      Friendship.find(fr_id.reverse).update(status: true)
    end

    def destroy_request(fr_id)
      Friendship.delete(Friendship.find(fr_id))
    end

    def destroy_friendship(user, rqstuser)
      friendship = Friendship.where(user_id: user, rqstuser_id: rqstuser).take
      inverse_friendship = Friendship.where(user_id: rqstuser, rqstuser_id: user).take
      friendship&.delete
      inverse_friendship&.delete
    end

    def friendship_exists?(user_id, rqstuser_id)
      Friendship.where(user_id: user_id, rqstuser_id: rqstuser_id).exists?
    end

    def second_row(fr_id)
      frd = Friendship.find(fr_id)
      return if Friendship.friendship_exists?(frd.rqstuser_id, frd.user_id)

      Friendship.create(user_id: frd.rqstuser_id, rqstuser_id: frd.user_id)
    end
  end

  def unique_friendship
    return if Friendship.where(user_id: rqstuser_id, rqstuser_id: user_id).empty?

    errors[:attribute] << 'Existing friendship'
    false
  end
end
