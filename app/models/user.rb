# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  phone                  :string
#  skype                  :string
#  sponsor_id             :integer
#  username               :string           not null
#  document_value         :string
#  birthdate              :date
#  address                :string
#  address_2              :string
#  country                :string
#  state                  :string
#  city                   :string
#  role                   :string           default("consumidor"), not null
#  binary_strategy        :string           default("balanced_strategy"), not null
#  binary_position        :string
#  bought_adhesion        :boolean          default(FALSE), not null
#  bought_product         :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_sponsor_id            (sponsor_id)
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord

  attr_accessor :login

  delegate :available_balance, :blocked_balance, to: :account

  before_create :create_default_account

  enum role: { consumidor: 'consumidor', empreendedor: 'empreendedor', admin: 'admin' }
  enum binary_strategy: {
    balanced_strategy: 'balanced_strategy',
    left_strategy: 'left_strategy',
    right_strategy: 'right_strategy'
  }
  enum binary_position: { left: 'left', right: 'right' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :masqueradable

  has_one :cloudinary_image, as: :imageable
  has_one :account
  has_one :binary_node
  has_many :orders
  has_many :financial_entries
  has_many :withdrawals
  has_many :pv_histories
  has_many :pv_activity_histories
  has_many :sponsored, class_name: 'User', foreign_key: 'sponsor_id'
  belongs_to :sponsor, class_name: 'User', optional: true

  has_many :credits
  has_many :debits
  has_many :bonus, class_name: 'Bonus'

  def avatar
    return CloudinaryImage.new.public_id unless cloudinary_image
    cloudinary_image.public_id
  end

  def can_receive_commission?
    bought_adhesion? && bought_product?
  end

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

  private

  def create_default_account
    build_account
  end

end
