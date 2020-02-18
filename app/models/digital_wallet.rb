class DigitalWallet < ApplicationRecord
  include Hashid::Rails

  enum status: { pending: 0, active: 1, inactive: 2 }

  belongs_to :user

  validates :address, presence: true

  after_save :change_user_wallet, if: :active?
  after_save :inactive_wallets, if: :active?

  def change_user_wallet
    user.update(wallet_address: address)
  end

  def inactive_wallets
    other_user_wallets.each(&:inactivate!)
  end

  def any_active?
    self.class.where(address: address, status: 1).any?
  end

  def other_user_wallets
    user.digital_wallets - [self]
  end

  def inactivate!
    update_attribute(:status, :inactive)
  end
end
