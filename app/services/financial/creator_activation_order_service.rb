module Financial
  class CreatorActivationOrderService < ApplicationService

    def call
      return unless activation_product
      order = nil
      ActiveRecord::Base.transaction do
        order = create_activation_order
        add_activation_item_to(order)
      end
      order
    end

    private

    attr_accessor :user, :activation_product

    def initialize(args)
      @user = args[:user]
      @activation_product = user.try(:current_career_trail).try(:activation_product)
    end

    def create_activation_order
      user.orders.create!(status: Order.statuses[:pending_payment],
                          total_cents: activation_product.price_cents,
                          subtotal_cents: activation_product.price_cents,
                          tax_cents: 0,
                          shipping_cents: 0,
                          expire_at: build_maturity_date)
    end

    def add_activation_item_to(order)
      order.order_items.create!(quantity: 1,
                                unit_price_cents: activation_product.price_cents,
                                total_cents: activation_product.price_cents,
                                product: activation_product)
    end

    def build_maturity_date
      maturity_day = find_nearest_maturity_day_from_current_day
      next_maturity_date = ensure_next_maturity_date
      Date.new(next_maturity_date.year, next_maturity_date.month, maturity_day)
    end

    def find_nearest_maturity_day_from_current_day
      maturity_days = activation_product.maturity_days.uniq.sort
      grace_period = activation_product.grace_period
      current_day = Date.current.day
      maturity_days.detect { |day| current_day <= day + grace_period } || maturity_days.last
    end

    def ensure_next_maturity_date
      date = first_activation? ? Date.current : find_last_activation_order.try(:expire_at)
      date + 1.month
    end

    def first_activation?
      find_last_activation_order.nil?
    end

    def find_last_activation_order
      @last_activation_order ||= OrderItem.includes(:order)
                                          .activation
                                          .where('orders.user': user)
                                          .last
                                          .try(:order)
    end

  end
end
