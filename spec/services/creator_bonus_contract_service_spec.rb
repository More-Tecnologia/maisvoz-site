require 'rails_helper'

RSpec.describe CreatorBonusContractService, type: :service do
  let(:service) { CreatorBonusContractService }

  before(:all) do
    CareerTrailFactory.create
    FinancialReasonFactory.create
  end

  context 'when order value less than 50' do
    context 'with order value not multiple of 5' do
      let(:order) { create(:order, :with_order_value_not_multiple_of_five) }

      subject { service.call(order: order) }

      it 'raise order value must be multiple of 5' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with order value multiple of 5' do
      let(:order) { create(:order, :with_order_value_multiple_of_five) }

      subject { service.call(order: order) }

      it 'create bonus contract' do
        expect(subject.persisted?).to be_truthy
      end

      it 'bonus contract expire_at in 30 days' do
        expect(subject.expire_at).to be_within(1.second).of(30.days.from_now)
      end

      it 'contract value 10x order value' do
        expect(subject.cent_amount).to eq(10*order.total_value)
      end

      it 'rentability be 0' do
        expect(subject.rentability).to be_zero
      end

      it 'loan contract be true' do
        expect(subject.loan).to be_truthy
      end

      it 'debit contract value from user balance' do
        bonus_contract = subject
        debit_value = order.user
                           .financial_transactions
                           .where(financial_reason: FinancialReason.deposit_less_than_fifty)
                           .last
                           .cent_amount
        expect(debit_value).to eq(bonus_contract.cent_amount)
      end
    end
  end

  context 'when order value greater than 50 and less than 100' do
    let(:order) { create(:order, :with_order_value_between_fifty_and_one_hundred) }

    subject { service.call(order: order) }

    it 'create bonus contract' do
      expect(subject.persisted?).to be_truthy
    end

    it 'contract value 2x order value' do
      expect(subject.cent_amount).to eq(2*order.total_value)
    end

    it 'rentability be contract value shared by 180 days' do
      contract_value_by_180 = (subject.cent_amount / 180.0).round(2).to_f
      expect(subject.rentability).to eq(contract_value_by_180)
    end

    it 'bonus contract expire in 180 days' do
      expect(subject.expire_at).to be_within(1.second).of(180.day.from_now)
    end
  end

  context 'when order value greater than or equal 100' do
    let(:order) { create(:order, :with_order_value_greater_than_or_equal_to_one_hundred) }

    subject { service.call(order: order) }

    it 'create bonus contract' do
      expect(subject.persisted?).to be_truthy
    end

    it 'contract value 2x order value' do
      expect(subject.cent_amount).to eq(2*order.total_value.to_f)
    end

    it 'rentability be contract value shared by 365 days' do
      contract_value_by_365 = (subject.cent_amount / 365.0).round(2).to_f
      expect(subject.rentability).to eq(contract_value_by_365)
    end

    it 'bonus contract expire in 1 year' do
      expect(subject.expire_at).to be_within(1.second).of(1.year.from_now)
    end
  end
end
