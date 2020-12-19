FactoryBot.define do
  factory :interaction do
    user { association(:user) }
    ticket { association(:ticket) }
    body { Faker::Lorem.paragraph }
    active { true }
    status { Ticket::STATUSES.keys.sample }
  end
end
