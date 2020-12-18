FactoryBot.define do
  factory :ticket do
    subject { association(:subject) }
    user { association(:user) }
    attendant_user { association(:user) }
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    status { Ticket::STATUSES.keys.sample }
    active { (rand(0..10) >= 7) ? false : true }
  end
end
