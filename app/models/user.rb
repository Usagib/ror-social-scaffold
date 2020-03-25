class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :delete_all
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'rqstuser_id', dependent: :delete_all

  # Methods

  # Return the user's friends list
  def friends
    friends_arr = friendships.map do |fr|
      fr.rqstuser if fr.status
    end

    friends_arr << inverse_friendships.map do |fr|
      fr.user if fr.status
    end

    friends_arr
  end

  # shows users which the current users had send friend requests
  def pending_friends
    friendships.map { |fr| fr.rqstuser unless fr.status }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |fr| fr.user unless fr.status }.compact
  end

  # Confirmation methods for request receiving user
  def confirm_friend(user)
    friendship = inverse_friendships.find { |fr| fr.user == user }
    friendship.status = true
    friendship.save
  end

  # Checks for friendship
  def friend?(user)
    friends.include?(user)
  end

  # Eliminates friendship
  def unfriend(user)
    Friendship.delete(Friendship.where(:user_id.eql?(id) && :rqstuser_id.eql?(user.id)))
  end

  def user_timeline
    Post.where(user: [self] + friends)
  end
end
