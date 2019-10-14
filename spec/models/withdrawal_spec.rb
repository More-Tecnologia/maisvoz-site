require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  let(:withdrawal) { create(:withdrawal) }

  before { CareerTrailFactory.create }

  it { is_expected.to have_many(:financial_transactions) }

  it 'has a valid factory' do
    expect(withdrawal.persisted?).to be_truthy
  end
end
