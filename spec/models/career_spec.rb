require 'rails_helper'

RSpec.describe Career, type: :model do
  let(:career) { create(:career) }

  it { is_expected.to validate_presence_of(:requalification_score) }
  it { is_expected.to validate_numericality_of(:requalification_score).only_integer }
  it { is_expected.to validate_uniqueness_of(:requalification_score) }
  it { is_expected.to have_many(:career_trails) }
  it { is_expected.to have_many(:trails).through(:career_trails) }
  it { is_expected.to have_many(:users) }

  it 'has valid factory' do
    expect(career.valid?).to be_truthy
  end
end
