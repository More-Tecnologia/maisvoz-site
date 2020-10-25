namespace :bonus_contracts do
  task create_received_balance_items: :environment do
    ActiveRecord::Base.transaction do
      BonusContract.find_each do |bonus_contract|
        received_balance = bonus_contract.received_balance

        bonus_contract.bonus_contract_items
                      .create!(cent_amount: received_balance) if received_balance.positive?
      end
    end
  end
end
