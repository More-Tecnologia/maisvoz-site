module Multilevel
  class QualifyUser

    def initialize(user)
      @user = user
    end

    def call
      return if binary_node.blank?

      user.update_column(:binary_qualified, qualified?)
      update_user_career
    end

    private

    attr_reader :user

    def update_user_career
      return unless user.affiliate? && qualified?
      ActiveRecord::Base.transaction do
        create_career_history
        user.unilevel_node.executive!
        user.update_column(:career_kind, User::EXECUTIVE)
      end
    end

    def create_career_history
      CareerHistory.new.tap do |log|
        log.user       = user
        log.old_career = user.career_kind
        log.new_career = User::EXECUTIVE
        log.save!
      end
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
