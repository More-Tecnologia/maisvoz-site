# == Schema Information
#
# Table name: club_motors_subscriptions
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :bigint(8)
#  car_model_id          :bigint(8)
#  chassis               :string
#  plate                 :string
#  cnpj_cpf              :string
#  owner_name            :string
#  manufacture_year      :string
#  model_year            :string
#  fuel                  :string
#  mileage               :integer
#  renavam               :string
#  gearbox               :string
#  taxi                  :boolean
#  mercosul_code         :string
#  color                 :string
#  color_type            :string
#  origin                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :string
#  type                  :string
#  approved_by_username  :string
#  current_period_start  :date
#  current_period_end    :date
#  activated_at          :datetime
#  balance_cents         :bigint(8)        default(0), not null
#  billing_day_of_month  :integer
#  current_billing_cycle :integer          default(0), not null
#  next_billing_date     :date
#  price_cents           :bigint(8)        default(0), not null
#  dr_response           :jsonb
#  dr_recorded           :boolean          default(FALSE)
#
# Indexes
#
#  index_club_motors_subscriptions_on_car_model_id  (car_model_id)
#  index_club_motors_subscriptions_on_user_id       (user_id)
#

class ClubMotorsSubscription < ApplicationRecord

  include Hashid::Rails

  self.inheritance_column = nil

  monetize :price_cents

  enum color_type: { solida: 'solida', metalica: 'metalica', perolizada: 'perolizada' }
  enum fuel: { gasolina: 'gasolina', etanol: 'etanol', diesel: 'diesel', flex: 'flex' }
  enum mercosul_code: { up_to_10: '87032100', from_10_to_15: '87032210', from_15_to_30: '87032310', from_30: '87043190', cargo: '87043190' }
  enum origin: { national: '0', imported_direct: '1', imported_internal: '2', national_import: '3', national_2: '4', national_3: '5' }
  enum gearbox: { manual: 'manual', automatic: 'automatic' }
  enum status: {
    inactive: 'inactive',
    past_due: 'past_due',
    expired: 'expired',
    canceled: 'canceled',
    pending: 'pending',
    active: 'active'
  }
  enum type: { clubmotors: 'clubmotors', ancore: 'ancore', tracker: 'tracker' }

  has_many :orders, as: :payable

  belongs_to :user
  belongs_to :car_model

  validates :plate, presence: true

  scope :active_subscriptions, -> { where(status: %i[pending past_due active]) }

  def name
    "#{car_model.car_brand.name} - #{car_model.name}"
  end

  def calculate_price_cents(product = user.product)
    if clubmotors?
      return 0 if product.blank?

      Subscriptions::CalculateClubMotorsFee.new(
        product: product,
        fee: car_model.club_motors_fee
      ).call
    elsif tracker?
      Subscriptions::CalculateTrackerFee.new(user: user, format: :cents).call
    else
      price_cents
    end
  end

end
