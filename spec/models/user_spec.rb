require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @testuser1 = User.create(name: 'User_sending', email: 'sender@user.com', password: '123456')
    @testuser2 = User.create(name: 'User_receiving', email: 'receiver@user.com', password: '123456')
  end

  context "User interaction with friendship" do

    it "friend request received" do
      @testuser1.friendships.build(rqstuser: @testuser2, status: false).save
      expect(@testuser2.friend_requests).to_not be(nil)
    end

    it "friend request sent" do
      @testuser1.friendships.build(rqstuser: @testuser2, status: false).save
      expect(@testuser1.pending_friends).to_not be(nil)
    end

    it "accept friend request" do
      @testuser1.friendships.build(rqstuser: @testuser2, status: false).save
      @testuser2.confirm_friend(@testuser1)
      expect(@testuser1.friends).to_not be(nil)
    end

    it "friend request gets accepted" do
      @testuser1.friendships.build(rqstuser: @testuser2).save
      @testuser2.confirm_friend(@testuser1)
      expect(@testuser2.friends.find(@testuser1)).to be_truthy
    end

    it "user gets unfriended" do
      @testuser1.friendships.build(rqstuser: @testuser2).save
      @testuser2.confirm_friend(@testuser1)
      @testuser1.unfriend(@testuser2)
      expect(@testuser1.friend?(@testuser2)).to be(false)
    end

  end

  context 'ActiveRecord Associations' do
    it { should have_many(:friendships) }
    it { should have_many(:inverse_friendships) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(20)  }
  end

end
