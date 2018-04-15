module Tasks
  class CheckLevelUp

    def self.call
      User.empreendedor.where(active: true, binary_qualified: true).find_each do |user|
        CheckUserLevelWorker.perform_async(user.id)
      end
    end

  end
end
