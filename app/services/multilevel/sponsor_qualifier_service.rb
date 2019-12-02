module Multilevel
  class SponsorQualifierService < ApplicationService

    def call
      user.sponsor.binary_qualify! if user_binary_node && qualified?
    end

    private

    attr_reader :user, :user_binary_node, :sponsor_binary_node, :sponsor_right_child,
                :sponsor_right_child

    def initialize(args)
      @user = args[:user]
      @user_binary_node = user.binary_node
      @sponsor_binary_node = user.try(:sponsor).try(:binary_node)
    end

    def qualified?
      return sponsor_other_leg_qualified? if user.active
      sponsor_binary_node.qualified?
    end

    def sponsor_other_leg_qualified?
      return sponsor_binary_node.right_leg_qualified? if sponsor_binary_node.left_child?(user_binary_node)
      sponsor_binary_node.left_leg_qualified? if sponsor_binary_node.right_child?(user_binary_node)
    end

    def binary_node
      @binary_node ||= user.binary_node
    end

  end
end
 5 
