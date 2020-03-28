require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @friend1 = User.create(name: 'User_sending', email: 'sender@user.com', password: '123456')
    @friend2 = User.create(name: 'User_receiving', email: 'receiver@user.com', password: '123456')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:rqstuser) }
  end

  # rubocop: disable Metrics/BlockLength
  context 'ApplicationRecord Test' do
    it 'should build valid friendship' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      expect(f).to be_valid
    end

    it 'should confirm existence if valid' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      expect(Friendship.friendship_exists?(f.user_id, f.rqstuser_id)).to be(true)
    end

    it 'should destroy friendship double row' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      f.destroy_friendship
      expect(Friendship.friendship_exists?(f.user_id, f.rqstuser_id)).to be(false)
      expect(Friendship.friendship_exists?(f.rqstuser_id, f.user_id)).to be(false)
    end

    it 'should confirm friendship' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      f.confirm_friend
      expect(f.reload.status).to be(true)
    end

    it 'should have composite primary key' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      f.confirm_friend
      expect(f.id).not_to be_empty
    end

    it 'should build second friendship row' do
      @friend1.friendships.build(rqstuser_id: @friend2.id).save
      f = @friend1.friendships.where(user_id: @friend1.id,
                                     rqstuser_id: @friend2.id).first
      f.confirm_friend
      expect(Friendship.friendship_exists?(f.rqstuser_id, f.user_id)).to be(true)
    end

    it 'shoul not be valid witn wrong arguments' do
      friendship = Friendship.create(user_id: '', rqstuser_id: @friend2.id)

      expect(friendship.valid?).to be(false)

      friendship = Friendship.create(user_id: @friend1.id, rqstuser_id: '')

      expect(friendship.valid?).to be(false)

      friendship = Friendship.create(user_id: '', rqstuser_id: '')

      expect(friendship.valid?).to be(false)
    end
  end
  # rubocop: enable Metrics/BlockLength
end
