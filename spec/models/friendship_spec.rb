require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:rqstuser) }
  end
end
