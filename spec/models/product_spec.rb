require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to have_many(:trail_products) }
  it { is_expected.to have_many(:trails).through(:trail_products) }
end
