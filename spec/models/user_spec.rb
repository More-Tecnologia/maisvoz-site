require 'rails_helper'

def find_ascendant_sponsors_ids(user)
  sponsors = []
  sponsor = user.sponsor
  while sponsor
    sponsors << sponsor
    sponsor = sponsor.sponsor
  end
  sponsors.map(&:id)
end

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  before(:all) do
    CareerTrailFactory.create
    TreeFactory.new.create_unilevel(3)
  end

  it { is_expected.to have_many(:career_trail_users) }
  it { is_expected.to have_many(:career_trails).through(:career_trail_users) }
  it { is_expected.to serialize(:ascendant_sponsors_ids).as(Array) }

  it 'valid factory' do
    expect(user.valid?).to be_truthy
  end

  context 'when create user' do
    it 'create unilevel node' do
      created_unilevel_node = user.unilevel_node.persisted?
      expect(created_unilevel_node).to be_truthy
    end

    it 'save ascendant sponsors ids' do
      user = User.last
      expected_sponsors_ids = find_ascendant_sponsors_ids(user)
      gotten_sponsor_ids = user.ascendant_sponsors.pluck(:id)
      expect(gotten_sponsor_ids).to eq(expected_sponsors_ids)
    end
  end
end
