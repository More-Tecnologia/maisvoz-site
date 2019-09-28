require 'rails_helper'

RSpec.describe Career, type: :model do
  let(:career) { create(:career) }

  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:career_trails) }
  it { is_expected.to have_many(:trails).through(:career_trails) }

  it 'has valid factory' do
    expect(career.valid?).to be_truthy
  end
end
