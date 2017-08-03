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
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
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
#  role                   :integer          default("0"), not null
#  binary_strategy        :integer          default("0")
#  binary_position        :integer
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

  enum role: { client: 0, financial: 1, support: 2, admin: 1337 }
  enum binary_strategy: { balanced_strategy: 0, left_strategy: 1, right_strategy: 2 }
  enum binary_position: { left: 0, right: 1 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable

  has_one :cloudinary_image, as: :imageable
  has_one :account
  has_one :binary_node
  has_many :orders
  has_many :financial_entries
  has_many :withdrawals
  has_many :pv_histories
  has_many :sponsored, class_name: 'User', foreign_key: 'sponsor_id'
  belongs_to :sponsor, class_name: 'User', optional: true

  def avatar
    return CloudinaryImage.new.public_id unless cloudinary_image
    cloudinary_image.public_id
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
