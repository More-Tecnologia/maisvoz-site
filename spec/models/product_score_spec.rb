require 'rails_helper'

RSpec.describe ProductScore, type: :model do
  it { is_expected.to belong_to(:career_trail) }
  it { is_expected.to validate_presence_of(:amount_cents) }
  it { is_expected.to validate_numericality_of(:amount_cents) }
  it { is_expected.to validate_presence_of(:generation) }
  it { is_expected.to validate_numericality_of(:generation).only_integer }
  it { is_expected.to belong_to(:product_reason_score) }
end
