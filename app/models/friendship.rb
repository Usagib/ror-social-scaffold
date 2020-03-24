class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :rqstuser, :class_name => "User"
end
