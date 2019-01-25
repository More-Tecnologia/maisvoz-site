namespace :subscriptions do
  desc 'Check status of active subscriptions'
  task check_status: :environment do
    Subscriptions::CheckStatus.new.call
  end

end
