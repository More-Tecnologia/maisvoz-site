module Backoffice
  module BonusContractsCsvHelper
    def render_bonus_contracts_as_csv(bonus_contracts)
      text = CSV.generate(col_sep: ';') do |csv|
               csv << csv_headers
               bonus_contracts.each do |bonus_contract|
                 csv << bonus_contract_to_csv(bonus_contract)
               end
             end
      send_bonus_contracts_to_csv_file(text)
    end

    private

    def csv_headers
      ['hashid',
       t(:deposit),
       Score.human_attribute_name(:amount),
       Score.human_attribute_name(:contract_balance),
       Score.human_attribute_name(:received_balance),
       Score.human_attribute_name(:in_date),
       Score.human_attribute_name(:username),
       Score.human_attribute_name(:status),
       Score.human_attribute_name(:processed_at)]
    end

    def bonus_contract_to_csv(bonus_contract)
      created_at = l(bonus_contract.created_at, format: :long) if bonus_contract.created_at
      paid_at = l(bonus_contract.paid_at, format: :long) if bonus_contract.paid_at

      [bonus_contract.hashid,
       bonus_contract.try(:order).try(:hashid),
       bonus_contract.cent_amount,
       bonus_contract.remaining_balance,
       bonus_contract.received_balance,
       created_at,
       bonus_contract.user.try(:username),
       bonus_contract.active? ? t('defaults.contract_active') : t('defaults.contract_expired'),
       paid_at]
    end

    def send_bonus_contracts_to_csv_file(text)
      send_data text, type: 'text/csv',
                      disposition: 'inline',
                      filename: t('defaults.bonus_contracts_csv', datetime: Date.current.to_s)
    end
  end
end
