module Multilevel
  class FetchUnilevelLeaderGenerations

    def initialize(user)
      @user = user
    end

    def call
      define_max_generation_level
      find_users(user.sponsored)
    end

    private

    attr_reader :user, :max_generation_level

    def find_users(users, all = [], leader_count = 0)
      users.each do |user|
        all << user

        if leader_count < max_generation_level - 1
          find_users(
            user.sponsored,
            all,
            user.leader? ? leader_count + 1 : leader_count
          )
        end
      end

      all
    end

    def define_max_generation_level
      @max_generation_level = if user.emerald?
                                1
                              elsif user.diamond?
                                2
                              elsif user.white_diamond?
                                3
                              elsif user.blue_diamond?
                                4
                              else
                                5
                              end
    end

  end
end
