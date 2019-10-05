require 'rails_helper'

def create_order
  odr = create(:order, user: user)
  Product.all.map { |product| create(:order_item, order: odr, product: product, quantity: 1) }
  odr
end

def sum_score_by_order
  sum_by_order_and_financial_reasons = order.products.size * financial_reasons_count
  return cent_amount * sum_by_order_and_financial_reasons if fix_value
  return (product_value * cent_amount / 100.0) * sum_by_order_and_financial_reasons
end

RSpec.describe Bonification::BonusPropagatorService, type: :service do
  let(:user) { User.where.not(username: ENV['MORENWM_USERNAME']).last }
  let(:order) { create_order }
  let(:ascendant_sponsors_size) { user.ascendant_sponsors.size }
  let(:financial_reason) {  }
  let!(:tree_height) { TreeFactory::HEIGHT }
  let!(:cent_amount) { ProductReasonScoreFactory::CENT_AMOUNT }
  let!(:financial_reasons_count) { ProductReasonScoreFactory::FINANCIAL_REASONS_COUNT }
  let!(:fix_value) { ProductReasonScoreFactory::FIX_VALUE }
  let!(:product_value) { ProductReasonScoreFactory::PRODUCT_VALUE }

  before do
    ProductReasonScoreFactory.create
    TreeFactory.new.create_unilevel
    Bonification::BonusPropagatorService.call(order: order)
  end

  it 'propagate bonus' do
    expected_bonus_amount = sum_score_by_order * tree_height
    gotten_bonus_amount = FinancialTransaction.not_chargeback.sum(:cent_amount)
    expect(gotten_bonus_amount).to be_within(30).of(expected_bonus_amount)
  end
end
