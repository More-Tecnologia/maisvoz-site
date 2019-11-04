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

  attr_accessor :login

  monetize :available_balance_cents, :blocked_balance_cents

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
  belongs_to :sponsor, class_name: 'User', optional: true
  belongs_to :product, optional: true

  has_many :credits
  has_many :debits
  has_many :investment_shares
  has_many :bonus, class_name: 'Bonus'

  validates :username, format: { with: /\A[a-z0-9\_]+\z/ }

  before_save :ensure_ascendant_sponsors_ids
  after_create :ensure_initial_career_trail
  after_create :touch_unilevel_node

  def balance
    (available_balance + blocked_balance).to_f
  end

  def balance_cents
    available_balance_cents + blocked_balance_cents
  end

  def unilevel_pva_count
    sponsored.sum(:pva_total)
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
    career_trails.last
  end

  def current_trail
    current_career_trail.try(:trail)
  end

  def current_career
    current_career_trail.try(:career)
  end

  def activate!
    update!(active: true, active_until: 1.month.from_now)
  end

  def out_binary_tree?
    user.binary_node.nil?
  end

  def inside_binary_tree?
    user.binary_node.nil?
  end

  def sponsor_is_binary_qualified?
    sponsor.try(:binary_qualified?)
  end

  def ascendant_sponsors
    User.where(id: ascendant_sponsors_ids)
        .empreendedor
        .reverse
  end

  def available_cent_amount
    credit_amount = FinancialTransaction.credit.where(user: self).sum(:cent_amount)
    debit_amount = FinancialTransaction.debit.where(user: self).sum(:cent_amount)
    credit_amount.to_i - debit_amount.to_i
  end

  def self.find_morenwm_customer_user
    find_by(username: ENV['MORENWM_CUSTOMER_USERNAME'])
  end

  def self.find_morenwm_user
    find_by(username: ENV['MORENWM_USERNAME'])
  end

  def next_career_kind
    current_career.next_career
  end

  def binary_unqualified?
    !binary_qualified?
  end

  def inactive?
    !active
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
end
