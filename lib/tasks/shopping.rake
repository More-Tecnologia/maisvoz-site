namespace :shopping do

  desc "Clear cart orders"
  task clear_cart: :environment do
    ClearCartOrdersWorker.perform_async
  end

end
