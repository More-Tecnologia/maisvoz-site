namespace :investments do

  task expire_old_orders: :environment do
    Investments::ExpireOlderOrders.call
  end

  task distribute_profits: :environment do
    Investments::Distribute.call
  end

end
