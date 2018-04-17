module Multilevel
  class QualifyUser

    def initialize(user)
      @user = user
    end

    def call
      return if binary_node.blank? || user.binary_qualified?
      user.update_column(:binary_qualified, qualified?)
      update_user_career
      credit_bonus
    end

    private

    attr_reader :user

    def update_user_career
      return unless user.affiliate? && qualified?
      ActiveRecord::Base.transacton do
        create_career_history
        user.update_column(:career_kind, User::EXECUTIVE)
      end
    end

    def create_career_history
      CareerHistory.new.tap do |log|
        log.user       = user
        log.old_career = user.career_kind
        log.new_career = USER::EXECUTIVE
        log.save!
      end
    end

    def credit_bonus
      Bonification::CreditFlexBonus.new(user).call
    end

    def qualified?
      @qualified ||= left_active? && right_active?
    end

    def left_active?
      BinaryNode.where(user: user.sponsored.left.where('active = true')).any?
    end

    def right_active?
      BinaryNode.where(user: user.sponsored.right.where('active = true')).any?
    end

    def binary_node
      @binary_node ||= user.binary_node
    end

  end
end
