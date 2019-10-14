require 'rails_helper'

RSpec.describe FinancialReasonType, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_numericality_of(:code).only_integer }
  it { is_expected.to have_many(:financial_reasons) }
end
