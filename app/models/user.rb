class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, foreign_key: 'user_id', dependent: :delete_all
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'rqstuser_id', dependent: :delete_all

  has_many :friends, -> { where(friendships: { status: true }) }, through: :friendships, source: :rqstuser
  scope :all_but, ->(user) { where.not(id: user) }
  # Methods

  # shows if a user has a pending friend
  def pending_friend?(user)
    friend_requests.include?(user)
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |fr| fr.user unless fr.status }.compact
  end

  # Checks for friendship
  def friend?(user)
    friends.include?(user)
  end

  def user_timeline
    Post.where(user: [self] + friends)
  end
end
