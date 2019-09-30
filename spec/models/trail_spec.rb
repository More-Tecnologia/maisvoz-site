require 'rails_helper'

RSpec.describe Trail, type: :model do
  let(:trail) { create(:trail) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to have_many(:career_trails) }
  it { is_expected.to have_many(:careers).through(:career_trails) }
  it { is_expected.to have_many(:trail_products) }
  it { is_expected.to have_many(:products).through(:trail_products) }

  it 'has valid factory' do
    expect(trail.valid?).to be_truthy
  end
end
