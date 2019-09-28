require 'rails_helper'

RSpec.describe CareerTrail, type: :model do
  let(:career_trail) { create(:career_trail) }

  it { is_expected.to belong_to(:career) }
  it { is_expected.to belong_to(:trail) }

  it 'have a valid factory' do
    expect(career_trail.valid?).to be_truthy
  end
end
