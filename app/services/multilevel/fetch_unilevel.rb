module Multilevel
  class FetchUnilevel

    prepend SimpleCommand

    def initialize(sponsor)
      @sponsor = sponsor
    end

    def call
      if sponsor.present?
        return direct_sponsored
      else
        errors.add(:sponsor, 'no binary node')
      end
      []
    end

    private

    attr_reader :sponsor

    def direct_sponsored
      User.where(sponsor: sponsor).map do |user|
        {
          sponsor: user.username,
          generations: generations(user.id).flatten
        }
      end
    end

    def generations(ids)
      return [] if ids.blank?

      children = User.where(sponsor_id: ids).pluck(:id)
      sponsors = User.where(sponsor_id: ids).map do |u|
        [u.sponsor.username, u.username, u.active, u.current_career.try(:name)]
      end

      return [] if children.size.zero?

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
