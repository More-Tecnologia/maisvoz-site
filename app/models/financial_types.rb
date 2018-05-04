module FinancialTypes

  BONUS_KINDS = %i[
    direct_indication_bonus executive_sale_bonus binary_bonus
    reverse_binary_bonus flex_bonus activity_bonus social_leader_bonus
    reverse_bonus bonus_chargeback
  ].freeze

  def self.included(base)
    base.enum kind: {
      direct_indication_bonus: 'direct_indication_bonus',
      executive_sale_bonus:    'executive_sale_bonus',
      binary_bonus:            'binary_bonus',
      reverse_binary_bonus:    'reverse_binary_bonus',
      flex_bonus:              'flex_bonus',
      activity_bonus:          'activity_bonus',
      social_leader_bonus:     'social_leader_bonus',
      reverse_bonus:           'reverse_bonus',
      bonus_chargeback:        'bonus_chargeback',
      credit_by_admin:         'credit_by_admin',
      debit_by_admin:          'debit_by_admin',
      fee:                     'fee',
      withdrawal_fee:          'withdrawal_fee',
      product_return:          'product_return',
      tax:                     'tax',
      transfer:                'transfer',
      withdrawal:              'withdrawal',
      third_order_payment:     'third_order_payment',
    }
  end

end
