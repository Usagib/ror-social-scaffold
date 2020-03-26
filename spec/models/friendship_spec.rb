require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @friend1 = User.create(name: 'Friend1', email: 'sender@user.com', password: '123456')
    @friend2 = User.create(name: 'Friend2', email: 'receiver@user.com', password: '123456')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:rqstuser) }
  end

  context 'ApplicationRecord Test' do

  end
end
