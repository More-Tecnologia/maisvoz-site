module Backoffice
  module BonusContractsHelper

    def bonus_contract_status(contract)
      return content_tag(:span, t('defaults.contract_active'), class: 'label label-success') if contract.active?
      content_tag(:span, t('defaults.contract_expired'), class: 'label label-danger')
    end

    def sum_previous_contract_by(attribute, q, bonus_contracts)
      first_contract_id = bonus_contracts.try(:first).try(:id)
      return 0 if first_contract_id.nil?
      sum = q.result
             .where('id <= ?', first_contract_id)
             .order(created_at: :desc)
             .sum(attribute.to_sym)
      sum / 1e2.to_f
    end

    def find_pool_point(order)
      ScoreType.pool_point.scores.where(order: order).first.try(:cent_amount).try(:to_i)
    end

  end
end
