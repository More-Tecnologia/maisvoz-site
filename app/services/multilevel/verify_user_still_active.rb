module Multilevel
  class VerifyUserStillActive

    def initialize(user, date)
      @user = user
      @date = Date.parse(date)
    end

    def call
      if has_minimum_sales?
        user.active = true
        user.active_until = 180.days.from_now.to_date
      else
        user.active = false
      end
      verify_sponsor_qualification
      halve_pva_counters

      user.save!
    end

    private

    attr_reader :user, :date

    def has_minimum_sales?
      @has_minimum_sales ||= user_purchases_count + client_purchases_count > 0
    end

    def verify_sponsor_qualification
      Multilevel::QualifyUser.new(user.sponsor).call
    end

    def halve_pva_counters
      user.sponsored.each do |u|
        u.update!(pva_total: u.pva_total / 2)
      end
    end

    def user_purchases_count
      user.orders.completed.where('paid_at >= ?', beginning_of_activity).count
    end

    def client_purchases_count
      Order.where(user: user.sponsored.consumidor).completed.where('paid_at >= ?', beginning_of_activity).count
    end

    def beginning_of_activity
      @beginning_of_activity ||= user.active_until - 180.days
    end

  end
end
