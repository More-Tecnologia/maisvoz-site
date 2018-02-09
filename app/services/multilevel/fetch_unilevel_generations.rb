module Multilevel
  class FetchUnilevelGenerations

    def initialize(user, generation_count = 6)
      @user             = user
      @generation_count = generation_count
    end

    def call
      find_users(user.id)
    end

    private

    attr_reader :user, :generation_count

    def find_users(ids)
      ids = User.where(sponsor_id: ids).pluck(:id)
      new_ids = ids.dup

      generation_count.times do
        break if ids.blank?

        ids = User.where(sponsor_id: ids).pluck(:id)
        new_ids.push(*ids)
      end

      new_ids
    end

  end
end
