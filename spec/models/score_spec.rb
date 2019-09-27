require 'rails_helper'

RSpec.describe Score, type: :model do
  it { is_expected.to validate_presence_of(:cent_amount) }
  it { is_expected.to validate_numericality_of(:cent_amount).only_integer }
  it { is_expected.to validate_numericality_of(:height).only_integer }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:spreader_user) }
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:spreader_user) }
  it { is_expected.to define_enum_for(:source_leg).with_values(Score::SOURCE_LEGS) }
end
