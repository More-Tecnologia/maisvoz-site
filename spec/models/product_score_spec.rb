require 'rails_helper'

RSpec.describe ProductScore, type: :model do
  it { is_expected.to belong_to(:career_trail) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to validate_presence_of(:cent_amount) }
  it { is_expected.to validate_numericality_of(:cent_amount).only_integer }
  it { is_expected.to validate_presence_of(:generation) }
  it { is_expected.to validate_numericality_of(:generation).only_integer }
end
