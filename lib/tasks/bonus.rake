namespace :bonus do
  task create_direct_and_indirect: :environment do
    ActiveRecord::Base.transaction do
      file_path = Rails.root.join('db/seeds/data/direct-and-indirect.csv')
      headers = %i[spreader user order_id amount generation]
      bonus = CSV.read(file_path, headers: headers, col_sep: ';')

      bonus.each do |bonus|
        spreader = User.find_by(username: bonus[:spreader])
        user = User.find_by(username: bonus[:user])
        financial_reason = bonus[:generation].to_i == 1 ? FinancialReason.direct_commission_bonus : FinancialReason.indirect_referral_bonus
        order = Order.find_by_hashid(bonus[:order_id])

        transaction = user.financial_transactions
                          .create!(spreader: spreader,
                                   financial_reason: financial_reason,
                                   order: order,
                                   cent_amount: bonus[:amount].gsub(',', '.').to_f)
        if user.inactive?
          reason = FinancialReason.indirect_referral_bonus_chargeback_by_inactivity
          reason = FinancialReason.direct_commission_bonus_chargeback if bonus[:generation].to_f == 1

          transaction.chargeback_by_inactivity!(reason)
        end
      end
    end
  end
end
