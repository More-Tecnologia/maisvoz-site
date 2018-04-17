class User
  module Careerable

    extend ActiveSupport::Concern

    included do
      CAREERS = [
        AFFILIATE = :affiliate,
        EXECUTIVE = :executive,
        BRONZE = :bronze,
        SILVER = :silver,
        GOLD = :gold,
        RUBY = :ruby,
        EMERALD = :emerald,
        DIAMOND = :diamond,
        WHITE_DIAMOND = :white_diamond,
        BLUE_DIAMOND = :blue_diamond,
        BLACK_DIAMOND = :black_diamond,
        CHAIRMAN = :chairman,
        CHAIRMAN_TWO_STAR = :chairman_two_star,
        CHAIRMAN_THREE_STAR = :chairman_three_star
      ]

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
      i = CAREERS.index(career_kind.to_sym)
      i ? CAREERS[i + 1] : '---'
    end

  end
end
