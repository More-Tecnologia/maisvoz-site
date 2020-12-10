module Types
  class QualifierService < ApplicationService
    def call
      qualify_user_by_type
      @user
    end

    private

    def initialize(args)
      @user = args[:user]
    end

    def qualify_user_by_type
      types = Type.order(indications_quantity: :desc, bonus_percentage: :desc)
      qualifier_type = types.detect { |type| qualify_user_by?(type) }

      @user.update!(type: qualifier_type) if qualifier_type
    end

    def qualify_user_by?(type)
      return valid_sponsored.length >= type.indications_quantity &&
             @user.active? if type.qualify_by_user_activity

      valid_sponsored.length >= type.indications_quantity
    end

    def valid_sponsored
      @valid_sponsored ||=
        user_bonus_contracts.select do |user, bonus_contracts|
          bonus_contracts.any? { |b| b.cent_amount >= max_bonus_contract_value }
        end
    end

    def user_bonus_contracts
      @user_bonus_contracts ||= BonusContract.includes(:user)
                                             .where(user: @user.sponsored)
                                             .active
                                             .yield_contracts
                                             .group_by(&:user)
    end

    def max_bonus_contract_value
      @max_bonus_contract_value ||= @user.bonus_contracts
                                         .active
                                         .yield_contracts
                                         .pluck(:cent_amount)
                                         .max.to_f / 100.0
    end
  end
end
