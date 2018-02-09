module Tasks
  class CheckActivityBonus

    def self.call
      return unless Time.zone.today == Time.zone.today.end_of_month
      User.empreendedor.where(active: true).find_each do |user|
        CheckActivityBonusWorker.perform_async(user.id)
      end
    end

  end
end
