require 'rails_helper'

RSpec.describe FinancialReason, type: :model do
  let(:financial_reason) { create(:financial_reason) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  it { is_expected.to have_many(:financial_transactions) }
  it { is_expected.to belong_to(:financial_reason_type) }

  it 'has valid factory' do
    expect(financial_reason.valid?).to be_truthy
  end
end
