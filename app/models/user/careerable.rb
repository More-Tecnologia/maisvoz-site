class User
  module Careerable

    extend ActiveSupport::Concern

    included do
      CAREERS = %w[
        affiliate
        executive
        bronze
        silver
        gold
        ruby
        emerald
        diamond
        white_diamond
        blue_diamond
        black_diamond
        chairman
        chairman_two_star
        chairman_three_star
      ].freeze

      enum career_kind: {
        affiliate: 'affiliate',
        executive: 'executive',
        bronze: 'bronze',
        silver: 'silver',
        gold: 'gold',
        ruby: 'ruby',
        emerald: 'emerald',
        diamond: 'diamond',
        white_diamond: 'white_diamond',
        blue_diamond: 'blue_diamond',
        black_diamond: 'black_diamond',
        chairman: 'chairman',
        chairman_two_star: 'chairman_two_star',
        chairman_three_star: 'chairman_three_star'
      }

      has_many :career_histories
    end

    def next_career_kind
      i = CAREERS.index(career_kind)
      i ? CAREERS[i + 1] : '---'
    end

  end
end
