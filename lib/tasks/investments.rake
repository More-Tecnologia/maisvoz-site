namespace :investments do

  task expire_old_orders: :environment do
    Investments::ExpireOlderOrders.call
  end

end
