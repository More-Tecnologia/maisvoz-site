# == Schema Information
#
# Table name: users
#
#  id                               :bigint(8)        not null, primary key
#  email                            :string           default(""), not null
#  encrypted_password               :string           default(""), not null
#  reset_password_token             :string
#  reset_password_sent_at           :datetime
#  remember_created_at              :datetime
#  sign_in_count                    :integer          default(0), not null
#  current_sign_in_at               :datetime
#  last_sign_in_at                  :datetime
#  current_sign_in_ip               :inet
#  last_sign_in_ip                  :inet
#  confirmation_token               :string
#  confirmed_at                     :datetime
#  confirmation_sent_at             :datetime
#  unconfirmed_email                :string
#  failed_attempts                  :integer          default(0), not null
#  unlock_token                     :string
#  locked_at                        :datetime
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  sponsor_id                       :bigint(8)
#  name                             :string
#  marital_status                   :string
#  gender                           :string
#  phone                            :string
#  skype                            :string
#  username                         :string           not null
#  registration_type                :string
#  document_cpf                     :string
#  document_rg                      :string
#  document_pis                     :string
#  document_cnpj                    :string
#  document_ie                      :string
#  document_company_name            :string
#  document_fantasy_name            :string
#  birthdate                        :date
#  zipcode                          :string
#  address_number                   :string
#  district                         :string
#  address                          :string
#  address_2                        :string
#  country                          :string
#  state                            :string
#  city                             :string
#  available_balance_cents          :bigint(8)        default(0), not null
#  blocked_balance_cents            :bigint(8)        default(0), not null
#  role                             :string           default("consumidor"), not null
#  binary_strategy                  :string           default("balanced_strategy"), not null
#  binary_position                  :string
#  bought_adhesion                  :boolean          default(FALSE), not null
#  bought_product                   :boolean          default(FALSE), not null
#  career_kind                      :string
#  pva_total                        :bigint(8)        default(0), not null
#  active                           :boolean          default(FALSE), not null
#  active_until                     :date
#  binary_qualified                 :boolean          default(FALSE), not null
#  bank_account                     :string
#  bank_agency                      :string
#  bank_code                        :string
#  address_ibge                     :string
#  document_refused_reason          :string
#  document_verification_status     :string
#  document_verification_updated_at :datetime
#  document_rg_expeditor            :string
#  product_id                       :bigint(8)
#  bank_account_type                :string
#
# Indexes
#
#  index_users_on_career_kind                   (career_kind)
#  index_users_on_confirmation_token            (confirmation_token) UNIQUE
#  index_users_on_document_cpf                  (document_cpf) UNIQUE
#  index_users_on_document_verification_status  (document_verification_status)
#  index_users_on_email                         (email) UNIQUE
#  index_users_on_product_id                    (product_id)
#  index_users_on_reset_password_token          (reset_password_token) UNIQUE
#  index_users_on_sponsor_id                    (sponsor_id)
#  index_users_on_unlock_token                  (unlock_token) UNIQUE
#  index_users_on_username                      (username) UNIQUE
#

class User < ApplicationRecord

  has_paper_trail

  attr_accessor :login

  enum role: { consumidor: 'consumidor', empreendedor: 'empreendedor', admin: 'admin', suporte: 'suporte', financeiro: 'financeiro', ecommerce: 'ecommerce' }
  enum marital_status: { single: 'single', married: 'married', widowed: 'widowed', divorced: 'divorced' }
  enum gender: { male: 'male', female: 'female' }
  enum registration_type: { pf: 'pf', pj: 'pj' }
  enum document_verification_status: { pending_verification: 'pending_verification', verified: 'verified', refused_verification: 'refused_verification' }

  enum binary_strategy: {
    balanced_strategy: 'balanced_strategy',
    left_strategy: 'left_strategy',
    right_strategy: 'right_strategy'
  }

  enum binary_position: { left: 'left', right: 'right' }

  serialize :ascendant_sponsors_ids, Array
  store :financial_transactions_checkpoint,
        accessors: [:financial_transaction_checkpoint_id, :financial_transaction_checkpoint_balance],
        coder: JSON

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :masqueradable

  has_attachment :avatar, accept: [:jpg, :png]
  has_attachment :document_rg_photo
  has_attachment :document_cpf_photo
  has_attachment :document_pis_photo
  has_attachment :document_address_photo
  has_attachment :document_scontract_photo
  has_one :account
  has_one :binary_node
  has_one :unilevel_node
  has_many :digital_wallets
  has_many :emails
  has_many :orders
  has_many :withdrawals
  has_many :pv_histories
  has_many :pv_activity_histories
  has_many :career_histories
  has_many :payment_transactions
  has_many :club_motors_subscriptions
  has_many :sponsored, class_name: 'User', foreign_key: 'sponsor_id'
  has_many :scores
  has_many :spreaded_scores, class_name: 'Score'
  has_many :career_trail_users, dependent: :destroy
  has_many :career_trails, through: :career_trail_users
  has_many :financial_transactions
  has_many :sim_cards
  has_many :supported_sim_cards, class_name: 'SimCard',
                                 foreign_key: 'support_point_user_id'
  has_many :supported_point_users, class_name: 'User',
                                   foreign_key: 'support_point_user_id'

  belongs_to :sponsor, class_name: 'User', optional: true
  belongs_to :product, optional: true
  belongs_to :role_type, class_name: 'RoleType',
                         foreign_key: 'role_type_code',
                         primary_key: 'code',
                         optional: true
  belongs_to :support_point_user, class_name: 'User',
                                  optional: true

  has_many :credits
  has_many :debits
  has_many :investment_shares
  has_many :bonus, class_name: 'Bonus'
  has_many :vouchers
  has_many :bonus_contracts

  validates :username, format: { with: /\A[a-z0-9\_]+\z/ }
  validates :bank_account_type, presence: true, on: :withdrawal
  validates :bank_account, presence: true, on: :withdrawal
  validates :bank_agency, presence: true, on: :withdrawal
  validates :bank_code, presence: true, on: :withdrawal
  validates :document_cpf_photo, presence: true, on: :document_verification
  validates :document_rg_photo, presence: true, on: :document_verification
  validates :document_pis_photo, presence: true, on: :document_verification, if: :pf?
  validates :document_address_photo, presence: true, on: :document_verification
  validates :document_scontract_photo, presence: true, on: :document_verification, if: :pj?
  validates :wallet_address, presence: true, on: :withdrawal_with_digital_coin

  validate :support_point_requisits, on: :update, if: :support_point?

  scope :bought_adhesion, -> { where(bought_adhesion: true) }
  scope :active,
    -> { ENV['ENABLED_ACTIVATION'] == 'true' ?
          where('active_until >= ?', Date.current).where(active: true) : where(active: true) }
  scope :inactive, -> { ENV['ENABLED_ACTIVATION'] == 'true' ?
                          where('active_until < ?', Date.current).or(User.where(active: false)) : where(active: false) }
  scope :support_point, -> { where(role_type_code: RoleType.support_point_code) }
  scope :by_location, ->(city, state) {
    where('lower(unaccent(city)) = ? AND lower(unaccent(state)) = ?',
          I18n.transliterate(city.to_s.strip.downcase),
          I18n.transliterate(state.to_s.strip.downcase)) }
  scope :by_support_point_and_consultant, ->(support_point, username) {
    where(support_point_user: support_point, username: username) }
  scope :with_support_point, -> { where.not(support_point_user: nil) }
  scope :without_support_point, -> { where(support_point_user: nil) }
  scope :created_after, ->(days) { where(created_at: days.days.ago.beginning_of_day..Time.now) }
  scope :with_blocked_mathing_bonus, -> { where('blocked_matching_bonus_balance > 0') }
  scope :with_blocked_pool_trading, -> { where('pool_tranding_blocked_balance > 0') }
  scope :with_children_pool_point_balance, -> { where('children_pool_trading_balance > 0') }

  before_save :ensure_ascendant_sponsors_ids
  after_create :ensure_initial_career_trail
  after_create :touch_unilevel_node
  after_create :insert_into_binary_tree

  after_update :ensure_digital_wallet_existence, unless: :active_digital_wallet?
  after_create :ensure_email_existence
  after_update :ensure_email_existence, unless: :active_email?

  def balance
    (available_balance + blocked_balance).to_f / 1e8
  end

  def available_balance
    amount = available_cent_amount
    amount > 0 ? amount - blocked_balance : amount
  end

  def blocked_balance
    blocked_balance_cents + withdrawal_order_amount + pool_tranding_blocked_balance +
    blocked_matching_bonus_balance
  end

  def available_balance_cents
    self[:available_balance_cents] / 1e8.to_f if self[:available_balance_cents]
  end

  def available_balance_cents=(amount)
    self[:available_balance_cents] = (amount * 1e8).to_i
  end

  def blocked_balance_cents
    self[:blocked_balance_cents] / 1e8.to_f if self[:blocked_balance_cents]
  end

  def blocked_balance_cents=(amount)
    self[:blocked_balance_cents] = (amount * 1e8).to_i
  end

  def withdrawal_order_amount
    self[:withdrawal_order_amount] / 1e8.to_f if self[:withdrawal_order_amount]
  end

  def withdrawal_order_amount=(amount)
    self[:withdrawal_order_amount] = (amount * 1e8).to_i
  end

  def active_digital_wallet
    digital_wallets.where(address: wallet_address)
  end

  def active_digital_wallet?
    active_digital_wallet.any?
  end

  def ensure_digital_wallet_existence
    digital_wallets.create(address: wallet_address, status: :active) if wallet_address.present?
  end

  def pool_tranding_blocked_balance
    self[:pool_tranding_blocked_balance] / 1e8.to_f if self[:pool_tranding_blocked_balance]
  end

  def pool_tranding_blocked_balance=(amount)
    self[:pool_tranding_blocked_balance] = (amount * 1e8).to_i
  end

  def unilevel_score_sum
    scores.unilevel.sum(:cent_amount)
  end

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  def month_pvg(ref_time = Time.zone.now)
    pv_activity_histories.where(
      'kind = ?', :pvg
    ).where(height: 1).where(
      'created_at >= ? AND created_at <= ?', ref_time.beginning_of_month, ref_time.end_of_month
    ).sum(:amount)
  end

  def destroy_documents!
    document_rg_photo.destroy! if document_rg_photo?
    document_cpf_photo.destroy! if document_cpf_photo?
    document_pis_photo.destroy! if document_pis_photo?
    document_address_photo.destroy! if document_address_photo?
    document_scontract_photo.destroy! if document_scontract_photo?
  end

  def touch_unilevel_node
    return if unilevel_node.present?
    sponsor_node = sponsor.present? ? sponsor.unilevel_node : nil
    UnilevelNode.create!(user: self, username: username, career_kind: career_kind, parent: sponsor_node)
  end

  def bank_name
    BankCodes.find_by_code(bank_code)
  end

  def current_career_trail
    career_trail_users.try(:last).try(:career_trail)
  end

  def current_trail
    current_career_trail.try(:trail)
  end

  def current_career
    current_career_trail.try(:career)
  end

  def current_career_trail_user
    career_trail_users.last
  end

  def activate!(active_until = 1.month.from_now)
    update!(active: true, active_until: active_until )
    update_sponsor_binary_qualified if ENV['ENABLED_BINARY'] == 'true'
  end

  def active_email
    emails.where(body: email)
  end

  def active_email?
    active_email.any?
  end

  def ensure_email_existence
    emails.create(body: email, status: :active)
  end

  def out_binary_tree?
    binary_node.nil?
  end

  def inside_binary_tree?
    binary_node
  end

  def sponsor_is_binary_qualified?
    sponsor.try(:binary_qualified?)
  end

  def insert_into_binary_tree
   if self.sponsor.present?
     Multilevel::CreateBinaryNode.new(self).call
   else
     BinaryNode.create(user: self)
   end
  end

  def ascendant_sponsors
    User.where(id: ascendant_sponsors_ids)
        .empreendedor
        .reverse
  end

  def available_cent_amount
    return calculate_available_balance_and_update_it_as_morenwm_user if morenwm_user?
    return calculate_available_balance_cents_and_update_it_as_customer_admin_user if customer_admin?
    calculate_available_balance_and_update_it
  end

  def self.find_morenwm_customer_user
    @@find_morenwm_customer_user ||= find_by(username: ENV['MORENWM_CUSTOMER_USERNAME'])
  end

  def self.find_morenwm_customer_admin
    @@find_morenwm_customer_admin_user ||= find_by(username: ENV['MORENWM_CUSTOMER_ADMIN'])
  end

  def self.find_morenwm_user
    @@find_morenwm_user ||= find_by(username: ENV['MORENWM_USERNAME'])
  end

  def update_blocked_balance!(amount)
    return increment(:blocked_balance_cents, amount.abs).save! if amount > 0
    decrement(:available_balance_cents, amount.abs).save!
  end

  def update_available_balance!(amount)
    return increment(:available_balance_cents, amount.abs).save! if amount > 0
    decrement(:available_balance_cents, amount.abs).save!
  end

  def next_career_kind
    current_career.next_career
  end

  def binary_unqualified?
    !binary_qualified?
  end

  def binary_qualified?
    binary_qualified
  end

  def active
    return self[:active] unless ENV['ENABLED_ACTIVATION'] == 'true'
    active_until && active_until >= Date.current && self[:active]
  end

  def active?
    active
  end

  def inactive?
    !active
  end

  def inactivate!
    update_attribute(:active, false)
    update_sponsor_binary_qualified if ENV['ENABLED_BINARY'] == 'true'
  end

  def binary_qualify!
    update_attribute(:binary_qualified, true)
  end

  def binary_unqualify!
    update_attribute(:binary_qualified, false)
  end

  def update_balance_cents!(amount)
    new_amount = (amount / 2.0) * 100.0
    attributes = { available_balance_cents: new_amount,
                   blocked_balance_cents: new_amount }
    update_attributes!(attributes)
  end

  def unilevel_ancestors
    unilevel_node.ancestors
                 .includes(:user)
                 .with_active_users
                 .map(&:user)
  end

  def sum_career_trail_bonus
    paid_at = find_current_trail_order_payment_date
    debits = financial_transactions.debit
                                   .financial_reason_bonus
                                   .where('financial_transactions.created_at >= ?', paid_at)
                                   .sum(:cent_amount)
    credits = financial_transactions.credit
                                    .financial_reason_bonus
                                    .where('financial_transactions.created_at >= ?', paid_at)
                                    .sum(:cent_amount)
    (credits - debits).to_f
  end

  def calculate_excess_career_trail_bonus
    return 0.0 unless current_career_trail.maximum_bonus
    maximum_bonus = current_career_trail.calculate_maximum_bonus
    balance = sum_career_trail_bonus.to_f
    balance.to_f - maximum_bonus.to_f
  end

  def find_current_trail_order_payment_date
    order_item = OrderItem.includes(:order)
                          .where('orders.user': self)
                          .where(product_id: current_trail.product.id)
                          .last
    order_item.try(:order).try(:paid_at)
  end

  def reached_career_trail_maximum_bonus?
    calculate_excess_career_trail_bonus > 0
  end

  def update_sponsor_binary_qualified
    sponsor_node = sponsor.try(:binary_node)
    sponsor.update_attributes!(binary_qualified: sponsor_node.qualified?) if sponsor_node
  end

  def support_point?
    role_type_code == RoleType.support_point_code
  end

  def morenwm_user?
    self == User.find_morenwm_user
  end

  def customer_admin?
    self == User.find_morenwm_customer_admin
  end

  def financial_transactions_by_user_role
    return FinancialTransaction.by_current_user(self)
                               .to_morenwm if morenwm_user?
    return FinancialTransaction.to_customer_admin if customer_admin?
    return FinancialTransaction.by_current_user(self)
                               .to_empreendedor
  end

  def lineage_scores
    @lineage_scores ||= Score.unilevel_scores_by_lineage(self, q = Score.ransack)
  end

  def increment_blocked_bonus!(amount)
    blocked_balance = blocked_balance_cents.to_f + amount.to_f
    update!(blocked_balance_cents: blocked_balance)
  end

  private

  def ensure_initial_career_trail
    first_career_trail = CareerTrail.first
    CareerTrailUser.create!(user: self, career_trail: first_career_trail)
  end

  def ensure_ascendant_sponsors_ids
    sponsor_ids = sponsor.try(:ascendant_sponsors_ids) || []
    sponsor_id = [sponsor.try(:id)]
    ids = sponsor_ids + sponsor_id
    self[:ascendant_sponsors_ids] = ids.compact
  end

  def support_point_requisits
    errors.add(:document_verification_status, :not_verified) unless verified?
    errors.add(:registration_type, :not_pj) unless pj?
  end

  def calculate_available_balance_cents_and_update_it_as_customer_admin_user
    credits = FinancialTransaction.to_customer_admin
                                  .from_id(financial_transaction_checkpoint_id.to_i)
                                  .company_credit
    debits = FinancialTransaction.to_customer_admin
                                 .from_id(financial_transaction_checkpoint_id.to_i)
                                 .company_debit
    last_transaction_id = [credits.try(:last).try(:id).to_i, debits.try(:last).try(:id).to_i].max
    return available_balance_cents unless last_transaction_id > financial_transaction_checkpoint_id.to_i

    new_balance = credits.sum(&:cent_amount) - debits.sum(&:cent_amount)
    new_balance += financial_transaction_checkpoint_balance.to_f
    update_abailable_balance_cents_and_financial_transaction_checkpoint(new_balance, last_transaction_id)
    available_balance_cents
  end

  def calculate_available_balance_and_update_it
    transactions = financial_transactions_by_user_role.from_id(financial_transaction_checkpoint_id.to_i).to_a
    last_transaction_id = transactions.try(:last).try(:id).to_i
    return available_balance_cents unless last_transaction_id > financial_transaction_checkpoint_id.to_i

    new_balance = transactions.select(&:credit?).sum(&:cent_amount) - transactions.select(&:debit?).sum(&:cent_amount)
    new_balance += financial_transaction_checkpoint_balance.to_f

    update_abailable_balance_cents_and_financial_transaction_checkpoint(new_balance, last_transaction_id)
    available_balance_cents
  end

  def calculate_available_balance_and_update_it_as_morenwm_user
    transactions = financial_transactions_by_user_role.from_id(financial_transaction_checkpoint_id.to_i).to_a
    last_transaction_id = transactions.try(:last).try(:id).to_i
    return available_balance_cents unless last_transaction_id > financial_transaction_checkpoint_id.to_i

    credits = transactions.select { |t| t.financial_reason.morenwm_moneyflow_credit? }.sum(&:cent_amount)
    debits = transactions.select { |t| t.financial_reason.morenwm_moneyflow_debit? }.sum(&:cent_amount)
    new_balance = (credits - debits) + financial_transaction_checkpoint_balance.to_f

    update_abailable_balance_cents_and_financial_transaction_checkpoint(new_balance, last_transaction_id)
    available_balance_cents
  end

  def update_abailable_balance_cents_and_financial_transaction_checkpoint(new_balance, last_transaction_id)
    update_attributes(financial_transaction_checkpoint_balance: new_balance,
                      available_balance_cents: new_balance,
                      financial_transaction_checkpoint_id: last_transaction_id)
  end

end
