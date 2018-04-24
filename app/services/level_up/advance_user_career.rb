module LevelUp
  class AdvanceUserCareer

    MAX_LIMIT = {
      ruby: 25_000,
      emerald: 50_000,
      diamond: 150_000,
      white_diamond: 350_000,
      blue_diamond: 800_000,
      black_diamond: 1_300_000,
      chairman: 1_500_000,
      chairman_two_star: 2_000_000,
      chairman_three_star: 5_000_000
    }.freeze

    def initialize(user)
      @user       = user
      @old_career = user.career_kind
    end

    def call
      if user.executive?
        advance_level(User.career_kinds[:bronze])
      elsif user.bronze?
        advance_level(User.career_kinds[:silver])
      elsif user.silver?
        advance_level(User.career_kinds[:gold])
      elsif user.gold?
        advance_level(User.career_kinds[:ruby])
      elsif user.ruby?
        advance_level(User.career_kinds[:emerald])
      elsif user.emerald?
        advance_level(User.career_kinds[:diamond])
      elsif user.diamond?
        advance_level(User.career_kinds[:white_diamond])
      elsif user.white_diamond?
        advance_level(User.career_kinds[:blue_diamond])
      elsif user.blue_diamond?
        advance_level(User.career_kinds[:black_diamond])
      elsif user.black_diamond?
        advance_level(User.career_kinds[:chairman])
      elsif user.chairman?
        advance_level(User.career_kinds[:chairman_two_star])
      elsif user.chairman_two_star?
        advance_level(User.career_kinds[:chairman_three_star])
      end
    end

    private

    attr_reader :user, :career_kind

    def advance_level(new_career)
      ActiveRecord::Base.transaction do
        CareerHistory.new.tap do |log|
          log.user       = user
          log.old_career = user.career_kind
          log.new_career = new_career
          log.save!
        end
        user.update!(career_kind: new_career)
        limit_sponsored_pva(new_career)
        update_unilevel_node_leadership(new_career)
      end
    end

    def limit_sponsored_pva(career)
      return unless MAX_LIMIT.fetch(career.to_sym, false)

      limit = MAX_LIMIT.fetch(career.to_sym)

      user.sponsored.each do |direct|
        direct.update!(pva_total: limit) if direct.pva_total > limit
      end
    end

    def update_unilevel_node_leadership(new_career)
      node = user.unilevel_node
      node.leader = true if new_career == User.career_kinds[:emerald]
      node.career_kind = new_career
      node.save!
    end

  end
end
