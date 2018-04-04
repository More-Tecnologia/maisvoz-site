module Multilevel
  class FetchUnilevel

    prepend SimpleCommand

    def initialize(sponsor)
      @sponsor = sponsor
      @root_binary_node = sponsor.binary_node
    end

    def call
      if root_binary_node
        return direct_sponsored
      else
        errors.add(:sponsor, 'no binary node')
      end
      []
    end

    private

    attr_reader :sponsor, :root_binary_node

    def direct_sponsored
      BinaryNode.where(sponsored_by_id: root_binary_node.user_id).includes(:user).map do |binary_node|
        {
          sponsor: binary_node.user.username,
          generations: generations(binary_node.user_id).flatten
        }
      end
    end

    def generations(ids)
      return [] if ids.blank?

      children = BinaryNode.where(sponsored_by_id: ids).pluck(:user_id)
      sponsors = User.where(sponsor_id: ids).pluck(:username)

      return [] if children.size == 0

      [
        {
          count: children.count,
          sponsors: sponsors
        },
        generations(children)
      ]
    end

  end
end
