class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :rqstuser, foreign_key: :rqstuser_id, class_name: 'User'
end
