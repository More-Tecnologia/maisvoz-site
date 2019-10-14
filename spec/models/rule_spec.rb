require 'rails_helper'

RSpec.describe Rule, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it {is_expected.to validate_uniqueness_of(:title).case_insensitive }
  it { is_expected.to belong_to(:rule_type) }
  it { is_expected.to have_many(:rule_ruleables) }
  it { is_expected.to have_many(:score_types).through(:rule_ruleables) }
end
