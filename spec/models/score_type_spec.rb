require 'rails_helper'

RSpec.describe ScoreType, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to have_many(:scores) }
  it { is_expected.to define_enum_for(:tree_type)
                      .with_values([:unilevel, :binary]) }
  it { is_expected.to have_many(:rule_ruleables) }
  it { is_expected.to have_many(:rules).through(:rule_ruleables) }
end
