require 'rails_helper'

RSpec.describe Financial::PaymentCompensation, type: :service do

  let(:user) { User.last }
  let(:order) { create(:order, :with_order_itens, user: user, status: :pending_payment) }
  let(:call) { Financial::PaymentCompensation.call(order) }

  before(:all) do
    CareerTrailFactory.create
    UserFactory.create
    TreeFactory.new.create_binary
    FinancialReasonFactory.create
    ScoreTypeFactory.create
  end

  it 'confirm payment' do
    expect(order.paid_at.present?).to be_truthy
  end

  it 'raise not exception' do
    expect { call }.to_not raise_exception
  end

end
