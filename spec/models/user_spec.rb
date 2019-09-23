require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'valid factory' do
    puts user.username
    expect(user.valid?).to be_truthy
  end

  context 'when create user' do
    it 'create unilevel node' do
      created_unilevel_node = user.unilevel_node.persisted?
      expect(created_unilevel_node).to be_truthy
    end
  end
end
