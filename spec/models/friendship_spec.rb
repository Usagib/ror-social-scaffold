require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:friend1) do
    User.create(name: 'Friend1',
                email: 'test1@friend.com',
                password: '123456')
  end
  let(:friend2) do
    User.create(name: 'Friend2',
                email: 'test2@friend.com',
                password: '123456')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:rqstuser) }
  end

  context 'ApplicationRecord Test' do
    it 'should build valid friendship' do
      friend1.friendships.build(rqstuser_id: friend2.id).save
      f = friend1.friendships.where(user_id: friend1.id,
                                    rqstuser_id: friend2.id).first
      expect(f).to be_valid
    end

    it 'should confirm friendship' do
      friend1.friendships.build(rqstuser_id: friend2.id).save
      f = friend1.friendships.where(user_id: friend1.id,
                                    rqstuser_id: friend2.id).first
      Friendship.confirm_friend(f.id)
      expect(f.reload.status).to be(true)
    end

    it 'should have composite primary key' do
      friend1.friendships.build(rqstuser_id: friend2.id).save
      f = friend1.friendships.where(user_id: friend1.id,
                                    rqstuser_id: friend2.id).first
      Friendship.confirm_friend(f.id)
      expect(f.id).to eq([10, 11])
    end

    it 'shoul not be valid witn wrong arguments' do
      friendship = Friendship.create(user_id: '', rqstuser_id: friend2.id)

      expect(friendship.valid?).to be(false)

      friendship = Friendship.create(user_id: friend1.id, rqstuser_id: '')

      expect(friendship.valid?).to be(false)

      friendship = Friendship.create(user_id: '', rqstuser_id: '')

      expect(friendship.valid?).to be(false)
    end
  end
end
