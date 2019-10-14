require 'rails_helper'

RSpec.describe Financial::CreatorSystemFeeService, type: :service do
  let(:morenwm_user) { create(:user, username: ENV['MORENWM_USERNAME']) }
  let(:order) { create(:order, :with_order_itens) }

  before do
    CareerTrailFactory.create
    5.times { create(:financial_reason) }
    morenwm_user
    Financial::CreatorSystemFeeService.call(order: order)
  end

  it 'create system fee' do
    order_cent_amount = order.taxable_product_cent_amount * ENV['SYSTEM_FEE'].to_d
    financial_transaction = FinancialTransaction.where(user: morenwm_user,
                                                       cent_amount: order_cent_amount.to_i).first
    expect(financial_transaction.persisted?).to be_truthy
  end

end
