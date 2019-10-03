module Bonification
  class IndirectBonusPropagatorService
    def call
      return if user.sponsor.blank? || order.adhesion_product.blank?
      ActiveRecord::Base.transaction do
        propagate_bonus_to_ascendant_sponsors
      end
    end

    private

    attr_reader :order. :user

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @product_scores = ProductScore.all
    end

    def propagate_bonus_to_ascendant_sponsors
      ascendant_sponsors = user.ascendant_sponsors
      ascendant_sponsors.each_with_index do |ascendant_sponsor, index|
        propagate_product_bonus(ascendant_sponsor, index + 1)
      end
    end

    def propagate_product_bonus(ascendant_sponsor, generation)
      order.products.each do |product|
        financial_transaction = create_financial_transaction(ascendant_sponsor, product, generation)
        financial_transaction.chargeback! unless ascendant_sponsor.active?
      end
    end

    def create_financial_transaction(ascendant_sponsor, product, generation)
      FinancialTransaction.create!(user: ascendant_sponsor,
                                   spreader: user,
                                   financial_reason: FinancialReason.indirect_bonus,
                                   cent_amount: find_cent_amount_by(career_trail, generation)
    end

    def find_cent_amount_by(args)
      product_score = ProductScore.where(career_trail: career_trail, generation: generation)
      product_score.cent_amount
    end
  end
end
