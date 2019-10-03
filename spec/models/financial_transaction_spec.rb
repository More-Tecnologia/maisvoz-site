require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  let(:financial_transaction) { create(:financial_transaction) }

  before { CareerTrailFactory.create }

  it { is_expected.to validate_presence_of(:cent_amount) }
  it { is_expected.to validate_numericality_of(:cent_amount).only_integer }
  it { is_expected.to belong_to(:financial_reason) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to define_enum_for(:moneyflow).with_values([:credit, :debit]) }
  it { is_expected.to belong_to(:spreader).class_name('User') }
  it { is_expected.to belong_to(:order).optional }

  it 'has valid factory' do
    expect(financial_transaction.valid?).to be_truthy
  end
end
