module Backoffice
  module SimCardsHelper

    def find_sim_card_cunsultant(support_point, username)
      consultant = User.by_support_point_and_consultant(support_point, username)
                       .first
      raise Exception, t('defaults.sim_card_inactive_user') if consultant&.inactive?
      consultant
    end

    def find_consultant_sim_cards(support_point, consultant, page)
      consultant ? consultant.sim_cards
                             .by_support_point(support_point)
                             .page(page) : []
    end

    def transfer_sim_cards_to(consultant, iccids, support_point)
      sim_cards = find_and_validates_support_point_sim_cards(support_point, iccids)
      ActiveRecord::Base.transaction do
        sim_cards.update_all(user_id: consultant.id, status: SimCard.statuses[:transfered])
      end
    end

    def find_and_validates_support_point_sim_cards(support_point, iccids)
      iccids = cleasing_iccids(iccids)
      available_sim_cards = support_point.supported_sim_cards
                                         .in_stock
                                         .available
                                         .by_iccids(iccids)
      validates_iccids(iccids, available_sim_cards)
      available_sim_cards
    end

    def cleasing_iccids(iccids)
      iccids.delete_if { |i| !i.present? }
    end

    def validates_iccids(iccids, available_sim_cards)
      available_iccids = available_sim_cards.map(&:iccid)
      unavailable_iccids = iccids.select { |i| !i.in?(available_iccids) }
      raise Exception, t('defaults.sim_card_unavailable_to_transfer', iccids: iccids.join(',')) if unavailable_iccids.any?
    end

    def hide_last_four_digits(phone_number)
      chars = phone_number.to_s.chars
      suffix = chars.pop(4).map { |c| "*" }
      (chars + suffix).join
    end

    def find_out_stock_search_attribute_by(user)
      user.support_point? ? :support_point_stock_out_at_eq : :user_stock_out_at_eq
    end

    def find_in_stock_search_attribute_by(user)
      user.support_point? ? :support_point_stock_in_at_eq : :user_stock_in_at_eq
    end

    def find_status_in_stock_search_attribute_by(user)
      user.support_point? ? :support_point_stock_out_at_null : :user_stock_out_at_null
    end

    def find_status_out_stock_search_attribute_by(user)
      user.support_point? ? :support_point_stock_out_at_not_null : :user_stock_out_at_not_null
    end

    def detect_stock_status_by(user, sim_card)
      stock_out_attribute = user.support_point? ? :support_point_stock_out_at : :user_stock_out_at
      sim_card.try(stock_out_attribute) ? t("attributes.out_stock") : t("attributes.in_stock")
    end

  end
end
