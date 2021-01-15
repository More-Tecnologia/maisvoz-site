require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  before(:all) do
    CareerTrailFactory.create
    TreeFactory.new.create_unilevel(3)
  end

  it { is_expected.to have_many(:financial_transactions) }
  it { is_expected.to have_many(:career_trail_users) }
  it { is_expected.to have_many(:career_trails).through(:career_trail_users) }
  it { is_expected.to serialize(:ascendant_sponsors_ids).as(Array) }
  it { is_expected.to belong_to(:role_type).optional }
  it { is_expected.to have_many(:sim_cards) }
  it { is_expected.to have_many(:sim_cards).class_name('SimCard') }
  it { is_expected.to have_many(:interactions) }
  it { is_expected.to have_many(:tickets) }
  it { is_expected.to belong_to(:career).optional }
  it { is_expected.to belong_to(:trail).optional }
  it { is_expected.to belong_to(:type).optional }

  it 'valid factory' do
    expect(user).to be_persisted
  end

  context 'when create user' do
    it 'create unilevel node' do
      created_unilevel_node = user.unilevel_node.persisted?
      expect(created_unilevel_node).to be_truthy
    end
  end
end
