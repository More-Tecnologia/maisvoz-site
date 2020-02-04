require 'rails_helper'

def build_params(payment_transaction)
  {
    payment_block_notification: {
    notification_code: payment_transaction.transaction_id
    }
  }
end

RSpec.describe Backoffice::PaymentBlockNotificationsController, type: :controller do
  let(:payment_transaction) { create(:payment_transaction) }

  describe 'POST create' do
    before do
      CareerTrailFactory.create
      request.headers['Authorization'] = ENV['AUTHORIZATION_KEY']
      post :create, params: build_params(payment_transaction)
    end

    it 'confirm transaction payment' do
      payment_transaction.reload
      expect(payment_transaction.paid?).to be_truthy
    end
  end
end
