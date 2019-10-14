require 'rails_helper'

RSpec.describe CareerTrailUser, type: :model do
  let(:career_trail_user) { create(:career_trail_user) }

  it { is_expected.to belong_to(:career_trail) }
  it { is_expected.to belong_to(:user) }

  it 'have a valid factory' do
    expect(career_trail_user.valid?).to be_truthy
  end
end
