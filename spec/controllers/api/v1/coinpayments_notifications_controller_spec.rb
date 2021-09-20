require 'rails_helper'

RSpec.describe Api::V1::CoinpaymentsNotificationsController, type: :controller do
  before(:all) { CareerTrailFactory.create }

  context 'with invalid header hmac' do
    let(:params) { CoinpaymentsIpnFactory.params }
    let(:invalid_key) { Faker::Internet.password }
    let(:invalid_header) { CoinpaymentsIpnFactory.header(invalid_key, params) }

    before { request.headers.merge!(invalid_header) }

    it 'response have http status code unauthorized' do
      post :create, params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when transaction paid' do
    let(:params) { CoinpaymentsIpnFactory.paid_params }
    let(:header) { CoinpaymentsIpnFactory.header(ENV['AUTHORIZATION_KEY'], params) }

    before do
      create(:payment_transaction, transaction_id: params[:txn_id], status: :started)
      request.headers.merge!(header)
    end

    it 'response have http status code no content' do
      post :create, params: params
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when transaction unpaid' do
    let(:params) { CoinpaymentsIpnFactory.unpaid_params }
    let(:header) { CoinpaymentsIpnFactory.header(ENV['AUTHORIZATION_KEY'], params) }

    before { request.headers.merge!(header) }

    it 'response have http status code unprocessable entity' do
      post :create, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
