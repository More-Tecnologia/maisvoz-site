module Bonification
  class PropagateOrderOfServicePoints

    def initialize(form)
      @form = form
    end

    def call
      return unless form.valid?

      ActiveRecord::Base.transaction do
        create_order_of_service
        create_pv_activity
      end
    end

    private

    attr_reader :form, :order_of_service

    def create_order_of_service
      @order_of_service = OrderOfService.new.tap do |os|
        os.user          = form.user
        os.created_by    = form.created_by
        os.os_number     = form.os_number
        os.gross_sales   = form.gross_sales
        os.net_sales     = form.net_sales
        os.gross_service = form.gross_service
        os.net_service   = form.net_service
        os.profit        = form.profit
        os.total_score   = form.total_score

        os.save!
      end
    end

    def create_pv_activity
      PvActivityHistory.create!(
        order_of_service: order_of_service,
        user:    sponsor,
        amount:  form.total_score,
        balance: sponsor.pva_total + form.total_score,
        kind:    'pvv',
        height:  1
      )
    end

    def sponsor
      @sponsor ||= form.user.sponsor
    end

  end
end
