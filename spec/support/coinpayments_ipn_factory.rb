module CoinpaymentsIpnFactory
  def self.params
    key = statuses.keys.sample
    status = statuses[key]

    {
      ipn_version: 1,
      ipn_type: 'api',
      ipn_mode: 'hmac',
      ipn_id: Faker::Number.number.to_s.to_i.to_s,
      merchant: Faker::Number.to_s.to_i.to_s,
      status: status,
      status_text: key.to_s,
      txn_id: Faker::Number.number.to_i.to_s,
      currency1: 'USD',
      currency2: 'BTC',
      amount1: Faker::Number.decimal.round(2),
      amount2: Faker::Number.decimal.round(2),
      fee: Faker::Number.decimal.round(2),
    }
  end

  def self.paid_params
    paid_statuses = statuses.slice(:queued, :complete)
    sample_key = paid_statuses.keys.sample

    params.merge(status: paid_statuses[sample_key],
                 status_text: sample_key)
  end

  def self.unpaid_params
    unpaid_statuses = statuses.except(:queued, :complete)
    sample_key = unpaid_statuses.keys.sample

    params.merge(status: unpaid_statuses[sample_key],
                 status_text: sample_key)
  end

  def self.statuses
    { refund: -2, cancelled: -1, waiting: 0, confirmed: 1,
      queued: 2, pending: 3, in_escrow: 5, complete: 100 }
  end

  def self.hmac(key, params)
    OpenSSL::HMAC.hexdigest('SHA512', key, URI.encode_www_form(params))
  end

  def self.header(key, params)
    { 'Content-Type': 'application/x-www-form-urlencoded',
      'HMAC': hmac(key, params) }
  end
end
