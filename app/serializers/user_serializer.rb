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

class UserSerializer

  def initialize(user)
    @user = user.decorate
  end

  def serialize
    {
      email: user.email,
      name: user.name_or_company_name,
      cpf_cnpj: user.main_document,
      gender: user.gender,
      birthdate: user.birthdate,
      type: user.registration_type,
      zipcode: user.zipcode,
      address_number: user.address_number,
      address: user.address,
      district: user.district,
      state: user.state,
      city: user.city,
      active: user.active,
    }.as_json
  end

  private

  attr_reader :user

end
