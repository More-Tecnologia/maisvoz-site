FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    name { Faker::Name.name}
    marital_status { User.marital_statuses.values.sample }
    gender { User.genders.values.sample }
    phone { Faker::PhoneNumber.phone_number.gsub(/\D+/,'') }
    username { I18n.transliterate(Faker::Name.last_name.downcase.gsub(/\W/,'')
                                  .concat(Faker::Number.positive.to_i.to_s)) }
    role { User.roles.values.sample }
    registration_type { User.registration_types.values.sample }
    document_verification_status { User.document_verification_statuses.values.sample }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 100) }
    binary_strategy { User.binary_strategies.values.sample }
    binary_position { User.binary_positions.values.sample }
    active { true }
    role_type { association(:role_type) }
  end
end
