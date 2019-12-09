require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:trail).optional }
  it { is_expected.to have_many(:career_trails) }
  it { is_expected.to serialize(:maturity_days) }
  it { is_expected.to validate_numericality_of(:grace_period).only_integer }
  it { is_expected.to validate_numericality_of(:grace_period).is_greater_than_or_equal_to(0) }
end
