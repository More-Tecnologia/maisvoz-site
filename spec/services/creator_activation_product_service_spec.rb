require 'rails_helper'

RSpec.describe Financial::CreatorActivationOrderService, type: :service do
  let(:user) { create(:user) }

  before { CareerTrailFactory.create }

  it 'creates activation order' do
    order = Financial::CreatorActivationOrderService.call(user: user)
    expect(order.persisted?).to be_truthy
  end
end
