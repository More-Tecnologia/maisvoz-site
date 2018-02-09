namespace :check_activity_bonus do
  desc "Deposita bonus referente a atividade dos últimos 30 dias"
  task verify: :environment do
    Tasks::CheckActivityBonus.call
  end

end
