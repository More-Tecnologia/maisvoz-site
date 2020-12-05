require 'rails_helper'

RSpec.describe Type, type: :model do
  let(:type) { build(:type) }

  it 'has a valid factory' do
    expect(type).to be_valid
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_numericality_of(:indications_quantity).only_integer }
  it { is_expected.to validate_numericality_of(:indications_quantity).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:bonus_percentage).is_greater_than_or_equal_to(0) }
  it { is_expected.to have_many(:users) }
end
