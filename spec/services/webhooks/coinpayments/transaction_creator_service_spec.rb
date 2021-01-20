require 'rails_helper'

RSpec.describe Webhooks::Coinpayments::TransactionCreatorService, type: :service do
  context 'when valid params' do
    let(:coinpayments_test_net_currency) { 'LTCT' }
    let(:valid_params) { { amount: Faker::Number.between(from: 1.0, to: 100.0).to_f,
                           current_currency: 'USD',
                           payment_currency: coinpayments_test_net_currency,
                           buyer_email: Faker::Internet.email } }

    subject { Webhooks::Coinpayments::TransactionCreatorService.call(valid_params) }

    it 'return success' do
      expect(subject.dig('error')).to eq('ok')
    end
  end

  context 'when invalid params' do
    let(:invalid_params) { { amount: Faker::Number.between(from: 1.0, to: 100.0).to_f,
                             current_currency: '',
                             payment_currency: '',
                             buyer_email: '' } }

    subject { Webhooks::Coinpayments::TransactionCreatorService.call(invalid_params) }

    it 'raise error' do
      expect { subject }.to raise_error
    end
  end
end
