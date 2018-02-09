namespace :users_still_active do
  desc "Verifica empreendedores que estão expirando no dia atual e checa se continuarão ativos"
  task verify: :environment do
    UsersActiveUntilTodayVerifierWorker.perform_async
  end

end
