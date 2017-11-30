module FinancialTypes

  def self.included(base)
    base.enum kind: {
      binary_bonus:     'binary_bonus',
      reverse_bonus:    'reverse_bonus',
      bonus_chargeback: 'bonus_chargeback',
      credit_by_admin:  'credit_by_admin',
      debit_by_admin:   'debit_by_admin',
      fee:              'fee',
      product_return:   'product_return',
      tax:              'tax',
      transfer:         'transfer',
      withdrawal:       'withdrawal'
    }
  end

end
