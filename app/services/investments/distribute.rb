module Investments
  class Distribute

    prepend SimpleCommand

    def call
      ActiveRecord::Base.transaction do
        InvestmentShare.active.where('next_bonus_payment <= ?', Time.zone.today).find_each do |share|
          credit_bonus(share)
          update_share(share)
        end
      end
    end

    private

    def credit_bonus(share)
      Bonification::Credit.call(
        user: share.user,
        order: nil,
        bonus_amount: share.bonus_amount,
        kind: FinancialEntry.kinds[:participation_bonus],
        description: "Bônus de participação da conta #{share.name}"
      )
    end

    def update_share(share)
      share.bonus_cycle        += 1
      share.profit_amount      += share.bonus_amount
      if share.bonus_cycle >= share.investment.investment_cycles
        share.finished!
      else
        share.next_bonus_payment = 30.days.from_now
      end
      share.save!
    end

  end
end
