# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  confirmation_token      :string
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string
#  failed_attempts         :integer          default(0), not null
#  unlock_token            :string
#  locked_at               :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  sponsor_id              :integer
#  name                    :string
#  marital_status          :string
#  gender                  :string
#  phone                   :string
#  skype                   :string
#  username                :string           not null
#  registration_type       :string
#  document_cpf            :string
#  document_rg             :string
#  document_pis            :string
#  document_cnpj           :string
#  document_ie             :string
#  document_company_name   :string
#  document_fantasy_name   :string
#  birthdate               :date
#  zipcode                 :string
#  address_number          :string
#  district                :string
#  address                 :string
#  address_2               :string
#  country                 :string
#  state                   :string
#  city                    :string
#  available_balance_cents :integer          default(0), not null
#  blocked_balance_cents   :integer          default(0), not null
#  role                    :string           default("consumidor"), not null
#  binary_strategy         :string           default("balanced_strategy"), not null
#  binary_position         :string
#  bought_adhesion         :boolean          default(FALSE), not null
#  bought_product          :boolean          default(FALSE), not null
#  career_kind             :string
#  pva_total               :integer          default(0), not null
#  active                  :boolean          default(FALSE), not null
#  active_until            :date
#  binary_qualified        :boolean          default(FALSE), not null
#  verified                :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_career_kind           (career_kind)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_sponsor_id            (sponsor_id)
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord

  attr_accessor :login

  monetize :available_balance_cents, :blocked_balance_cents

  enum role: { consumidor: 'consumidor', empreendedor: 'empreendedor', admin: 'admin' }
  enum marital_status: { single: 'single', married: 'married', widowed: 'widowed', divorced: 'divorced' }
  enum gender: { male: 'male', female: 'female' }
  enum registration_type: { pf: 'pf', pj: 'pj' }

  enum binary_strategy: {
    balanced_strategy: 'balanced_strategy',
    left_strategy: 'left_strategy',
    right_strategy: 'right_strategy'
  }

  enum binary_position: { left: 'left', right: 'right' }

  enum career_kind: {
    affiliate: 'affiliate',
    executive: 'executive',
    bronze: 'bronze',
    silver: 'silver',
    gold: 'gold',
    ruby: 'ruby',
    emerald: 'emerald',
    diamond: 'diamond',
    white_diamond: 'white_diamond',
    blue_diamond: 'blue_diamond',
    black_diamond: 'black_diamond',
    chairman_club: 'chairman_club',
    chairman_club_two_star: 'chairman_club_two_star',
    chairman_club_three_star: 'chairman_club_three_star'
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :masqueradable

  has_one :cloudinary_image, as: :imageable
  has_attachment :document_rg_photo
  has_attachment :document_cpf_photo
  has_attachment :document_pis_photo
  has_attachment :document_address_photo
  has_attachment :document_scontract_photo
  has_one :account
  has_one :binary_node
  has_many :orders
  has_many :financial_entries, class_name: 'FinancialEntry'
  has_many :withdrawals
  has_many :pv_histories
  has_many :pv_activity_histories
  has_many :sponsored, class_name: 'User', foreign_key: 'sponsor_id'
  belongs_to :sponsor, class_name: 'User', optional: true

  has_many :credits
  has_many :debits
  has_many :bonus, class_name: 'Bonus'
  has_many :career_histories

  def avatar
    return CloudinaryImage.new.public_id unless cloudinary_image
    cloudinary_image.public_id
  end

  def balance
    (available_balance + blocked_balance).to_f
  end

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  def leader?
    emerald?
    true
  end

end
