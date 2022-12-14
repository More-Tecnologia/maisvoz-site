require 'rails_helper'

RSpec.describe ProductReasonScore, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:financial_reason) }
  it { is_expected.to have_many(:product_scores) }
end
