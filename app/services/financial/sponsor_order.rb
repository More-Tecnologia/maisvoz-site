module Financial
  class SponsorOrder < PaymentCompensation

    private

    def compensate_order
      order.with_lock do
        update_order_totals
        update_order_status
        update_user_flags
        update_user_role
        update_subscription
        activate_user
        assign_product_to_user
        create_binary_node
        qualify_sponsor
        order.completed!
      end
      ShoppingMailer.with(order: order).order_paid.deliver_later
      DROrderTransmitterWorker.perform_async(order.id)
      true
    end

    def update_order_totals
      order.total = 0
      order.subtotal = 0
      order.save!

      order.order_items.each do |item|
        item.unit_price = 0
        item.total = 0
        item.save!
      end
    end

  end
end
