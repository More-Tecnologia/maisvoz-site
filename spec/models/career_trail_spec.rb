require 'rails_helper'

RSpec.describe CareerTrail, type: :model do
  let(:career_trail) { create(:career_trail) }

  it { is_expected.to belong_to(:career) }
  it { is_expected.to belong_to(:trail) }
  it { is_expected.to have_many(:career_trail_users) }
  it { is_expected.to have_many(:users).through(:career_trail_users) }
  it { is_expected.to have_one(:product_score) }

  it 'have a valid factory' do
    expect(career_trail.valid?).to be_truthy
  end
end
