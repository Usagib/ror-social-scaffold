require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @friend1 = User.create(name: 'Friend1', email: 'test1@friend.com', password: '123456')
    @friend2 = User.create(name: 'Friend2', email: 'test2@friend.com', password: '123456')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:rqstuser) }
  end

  context 'ApplicationRecord Test' do
    it 'should confirm friendship' do
      f = @friend1.friendships.build(rqstuser: @friend2, status: false)
      f.save
      confirm_friend(f.id)
      expect(f.status).to be(true)
    end
  end
end
