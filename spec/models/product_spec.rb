require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:trail).optional }
  it { is_expected.to have_many(:career_trails) }
  it { is_expected.to serialize(:maturity_days) }
end
