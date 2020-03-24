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
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "rqstuser_id"


  # Methods

  def friends
    friends_arr = friendships.map do |friendship|
      friendship.rqstuser if friendship.status
    end

    friends_arr + inverse_friendships.map do |friendship|
      friendship.user if friendship.status
    end

    friends_arr.compact
  end

  def pending_friends
    friendships.map{ |friendship| friendship.rqstuser if !friendship.status }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map{ |friendship| friendship.user if !friendship.status }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find{ |friendship| friendship.user == user }
    friendship.status = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end
end
