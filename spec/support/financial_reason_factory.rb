module FinancialReasonFactory

  def self.create
    administrative_type = FinancialReasonType.find_or_create_by!(name: 'Administrativo Financeiro', code: '100')
    administrative_reasons = [{ title: 'System Fee', code: '200', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                              { title: 'Withdrawal', code: '300', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                              { title: 'Withdrawal Fee', code: '400', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                              { title: 'Order Payment', code: '1200', company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                              { title: 'Credit', code: '2800', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                              { title: 'Debit', code: '2900', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                              { title: 'Expense', code: '3800', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                              { title: 'Order Sponsored', code: '4100', company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                              { title: 'Deposit Less Than 50', code: '4200', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable }]
    administrative_reasons.each do |r|
      FinancialReason.find_or_create_by!(r.merge({financial_reason_type: administrative_type}))
    end
    bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
    bonus_reasons = [{ title: 'Bonus chargeback', code: '100', active: false, company_moneyflow: :credit },
                     { title: 'Binary Bonus', code: '500', active: true, company_moneyflow: :debit   },
                     { title: 'Binary Bonus Chargeback for Inactivity', code: '600', active: true, company_moneyflow: :credit  },
                     { title: 'Binary Bonus Chargeback for Monthly Excess', code: '700', active: false, company_moneyflow: :credit  },
                     { title: 'Weekly Excess Binary Bonus Chargeback', code: '800', active: false, company_moneyflow: :credit  },
                     { title: 'Career Limit Bonus Chargeback', code: '900', active: false, company_moneyflow: :credit  },
                     { title: 'Referral Bonus', code: '1000', active: false, company_moneyflow: :debit },
                     { title: 'Yield Bonus', code: '1100', active: false, company_moneyflow: :debit },
                     { title: 'Binary Bonus Chargeback by Disqualification', code: '1300', active: true, company_moneyflow: :credit },
                     { title: 'Residual Support Point Bonus', code: '1400', active: false, company_moneyflow: :debit },
                     { title: 'Residual Support Point Inactivity Bonus Chargeback', code: '3000', active: false, company_moneyflow: :credit},
                     { title: 'Start Fast Bonus', code: '2000', active: true, company_moneyflow: :debit  },
                     { title: 'Chargeback Start Fast Bonus for Inactivity', code: '2100', active: true, company_moneyflow: :credit },
                     { title: 'Indirect Referral Bonus', code: '2200', active: false, company_moneyflow: :debit },
                     { title: 'Bonus Chargeback Indirect Inactivity Referral', code: '2300', active: false, company_moneyflow: :credit },
                     { title: 'Activation Bonus', code: '2400', dynamic_compression: true, active: false, company_moneyflow: :debit },
                     { title: 'Inactivity Activation Bonus Chargeback', code: '2500', active: false, company_moneyflow: :credit },
                     { title: 'Residual Bonus', code: '2600', dynamic_compression: false, active: false, company_moneyflow: :debit },
                     { title: 'Residual Bonus Chargeback for Inactivity', code: '2700', active: false, company_moneyflow: :credit },
                     { title: 'Support Point Activation Bonus', code: '3100', active: false, company_moneyflow: :debit },
                     { title: 'Bonus Chargeback Activation of Inactivity Support Point', code: '3200', active: false, company_moneyflow: :credit },
                     { title: 'Binary Bonus Chargeback for Daily Excess', code: '3300', active: true, company_moneyflow: :credit },
                     { title: 'Bonus Chargeback for Contract Limit', code: '3400', active: true, company_moneyflow: :credit },
                     { title: 'Pool Cash', code: '3500', active: true, company_moneyflow: :debit },
                     { title: 'Equilibrium Bonus', code: '3600', active: true, company_moneyflow: :debit },
                     { title: 'Equilibrium Bonus Chargeback by Inactivity', code: '3700', active: true, company_moneyflow: :credit },
                     { title: 'Pool Leadership', code: '3900', active: true, company_moneyflow: :credit },
                     { title: 'Pool Leadership Chargeback by Inactivity', code: '4000', active: true, company_moneyflow: :credit }]
    bonus_reasons.each do |r|
      FinancialReason.find_or_create_by!(r.merge({financial_reason_type: bonus_type}))
    end

  end
end
