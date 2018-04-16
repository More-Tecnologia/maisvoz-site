module LevelUp
  class CheckUser

    def initialize(user)
      @user = user
    end

    def call
      verify_career
    end

    private

    attr_reader :user

    def verify_career
      return unless user.active?
      return unless user.binary_qualified?
      return unless can_advance_career?
      advance_user_career
    end

    def can_advance_career?
      user.executive? && generations_pva_sum >= 3_500 ||
        user.bronze? && generations_pva_sum >= 10_500 ||
        user.silver? && generations_pva_sum >= 35_000 ||
        user.gold? && sum_pva_limit(25_000) >= 150_000 ||
        user.ruby? && sum_pva_limit(50_000) >= 350_000 ||
        user.emerald? && sum_pva_limit(150_000) >= 1_050_000 ||
        user.diamond? && sum_pva_limit(350_000) >= 2_300_000 ||
        user.white_diamond? && sum_pva_limits(800_000, 6, 500_000) >= 6_800_000 ||
        user.blue_diamond? && sum_pva_limits(1_300_000, 8, 600_000) >= 12_800_000 ||
        user.black_diamond? && sum_pva_limits(1_500_000, 8, 800_000) >= 35_000_000 ||
        user.chairman? && sum_pva_limits(2_000_000, 9, 1_000_000) >= 70_000_000 ||
        user.chairman_two_star? && sum_pva_limits(5_000_000, 10, 1_000_000) >= 100_000_000
    end

    def advance_user_career
      LevelUp::AdvanceUserCareer.new(user).call
    end

    def sum_pva_limit(max_limit)
      return 0 unless origin_qualification_line?(max_limit)

      generations_pva.collect { |i| i > max_limit ? max_limit : i }.sum
    end

    def sum_pva_limits(first_limit, quantity, second_limit)
      return 0 unless origin_qualification_line?(second_limit)

      ar = []
      arb = []

      generations_pva.each do |i|
        if i >= first_limit && ar.count < quantity
          ar.push(first_limit)
        else
          arb.push(i > second_limit ? second_limit : i)
        end
      end

      (ar + arb).sum
    end

    def generations_pva
      @generations_pva ||= user.sponsored.pluck(:pva_total)
    end

    def generations_pva_sum
      @generations_pva_sum ||= generations_pva.sum
    end

    def origin_qualification_line?(min_limit)
      user.sponsored.where(binary_position: user.binary_position)
        .where('pva_total >= ?', min_limit).any?
    end

  end
end
