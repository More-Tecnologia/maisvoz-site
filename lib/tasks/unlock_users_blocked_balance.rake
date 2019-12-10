namespace :unlock_users_blocked_balance do
  desc 'Desbloqueia saldos de usuários'
  task verify: :environment do
    AutoUnlockUsersBlockedBalanceWorker.perform_async
  end
end
