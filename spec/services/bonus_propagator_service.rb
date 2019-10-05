require 'rails_helper'

def create_order
  odr = create(:order, user: user)
  Product.all.map { |product| create(:order_item, order: odr, product: product, quantity: 1) }
  odr
end

RSpec.describe Bonification::BonusPropagatorService, type: :service do
  let(:user) { User.where.not(username: ENV['MORENWM_USERNAME']).last }
  let(:order) { create_order }
  let(:ascendant_sponsors_size) { user.ascendant_sponsors.size }
  let!(:tree_height) { TreeFactory::HEIGHT }
  let!(:bonus_fee) { ProductReasonScoreFactory::PRODUCT_SCORE }

  before do
    ProductReasonScoreFactory.create
    TreeFactory.new.create_unilevel
    Bonification::BonusPropagatorService.call(order: order)
  end

  it 'propagate bonus' do
    expected_bonus_amount = bonus_fee * order.products.size * tree_height
    gotten_bonus_amount = FinancialTransaction.not_chargeback.sum(:cent_amount)
    expect(gotten_bonus_amount).to eq(expected_bonus_amount)
  end
end
