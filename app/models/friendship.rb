class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :rqstuser, foreign_key: :rqstuser_id, class_name: 'User'

  validates :user_id, presence: true
  validates :rqstuser_id, presence: true
end
