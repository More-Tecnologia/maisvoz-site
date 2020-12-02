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
      types = Type.order(indications_quantity: :desc)
      qualifier_type = types.detect { |type| qualify_user_by?(type, @user) }

      @user.update!(type: qualifier_type) if qualifier_type
    end

    def qualify_user_by?(type, user)
      active_indications_quantity = @user.sponsored.active.count

      return active_indications_quantity >= type.indications_quantity &&
             @user.active? if type.qualify_by_user_activity

      active_indications_quantity >= type.indications_quantity
    end
  end
end
