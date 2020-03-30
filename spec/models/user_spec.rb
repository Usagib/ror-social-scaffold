require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @testuser1 = User.create(name: 'User_sending', email: 'sender@user.com', password: '123456')
    @testuser2 = User.create(name: 'User_receiving', email: 'receiver@user.com', password: '123456')
  end

  context 'User interaction with friendship' do
    it 'friend request received' do
      @testuser1.friendships.build(rqstuser: @testuser2, status: false).save
      expect(@testuser2.friend_requests).to_not be(nil)
    end

    it 'friend request sent' do
      @testuser1.friendships.build(rqstuser: @testuser2, status: false).save
      expect(@testuser1.friend_requests).to_not be(nil)
    end
  end

  context 'User content interaction' do
    it 'can create posts' do
      @testuser1.posts.build(content: 'Lorem ipsum dolor asimet').save
      expect(@testuser2.posts).to_not be(nil)
    end

    it 'can like posts' do
      @testuser1.posts.build(content: 'Lorem ipsum dolor asimet').save
      @testuser1.likes.create(post_id: 1)
      expect(@testuser1.likes.first.user_id).to be_kind_of(Integer)
    end
  end

  context 'ActiveRecord Associations' do
    it { should have_many(:friendships) }
    it { should have_many(:inverse_friendships) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:friends) }
  end

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(20) }
  end
end
