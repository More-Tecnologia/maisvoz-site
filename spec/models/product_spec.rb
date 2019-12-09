require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:trail).optional }
  it { is_expected.to have_many(:career_trails) }
end
