require 'rails_helper'

RSpec.describe RuleType, type: :model do
  let(:create) { create(:rule_type) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:ruleable_name) }
  it { is_expected.to validate_uniqueness_of(:ruleable_name).case_insensitive }
  it { is_expected.to have_many(:rules) }
end
