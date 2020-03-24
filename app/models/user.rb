class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'rqstuser_id'

  # Methods

  def friends
    friends_arr = friendships.map do |fr|
      fr.rqstuser if fr.status
    end

    friends_arr << inverse_friendships.map do |fr|
      fr.user if fr.status
    end

    friends_arr.compact
  end

  def pending_friends
    friendships.map { |fr| fr.rqstuser unless fr.status }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |fr| fr.user unless fr.status }.compact
  end

  def confirm_friend(user)
    friendship = friendships.find { |fr| fr.rqstuser_id == user.id }
    friendship.status = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end
end
