namespace :end_of_month_auto_withdraw_task do
  desc 'Realiza saques automáticos do saldo restante dos usuários'
  task verify: :environment do
    LastDayAutoWithdrawWorker.perform_async
  end
end
