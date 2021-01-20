class PaymentTransaction < ApplicationRecord

  include Hashid::Rails

  serialize :provider_response, JSON

  attr_accessor :wallet_address

  belongs_to :order

  enum status: [:started, :paid]

  validates :transaction_id, presence: true,
                             uniqueness: true

  serialize :provider_response, JSON

  def wallet_label
    hashid
  end

  def amount=(value)
    self[:amount] = to_eight_scale(value)
  end

  def paid_with_provider_response!(response)
    update(status: :paid,
           provider_response: response)
  end

  private

  def to_eight_scale(value)
    (value.to_f * 10e7).to_i / 10e7
  end
end
