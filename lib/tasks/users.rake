namespace :users do

  task check_level: :environment do
    Tasks::CheckLevelUp.call
  end

end
