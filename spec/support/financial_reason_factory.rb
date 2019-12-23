module FinancialReasonFactory

  def self.create
    administrative_type = FinancialReasonType.find_or_create_by!(name: 'Administrativo Financeiro', code: '100')
    administrative_reasons = [{ title: 'Taxa do Sistema', code: '200' },
                              { title: 'Saque', code: '300' },
                              { title: 'Taxa de Saque', code: '400' }]
    administrative_reasons.each do |r|
      FinancialReason.find_or_create_by!(r.merge({financial_reason_type: administrative_type}))
    end
    bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
    bonus_reasons = [{ title: 'Estorno de Bonus', code: '100' },
                     { title: 'Bonus Binário', code: '500'},
                     { title: 'Estorno de Bonus Binário por Limite de Tempo', code: '600' },
                     { title: 'Estorno de Bonus Binário por Excesso Mensal', code: '700' },
                     { title: 'Estorno de Bonus Binário por Excesso Semanal', code: '800' },
                     { title: 'Estorno de Bonus por Limite na Careeira', code: '900' }]
    bonus_reasons.each do |r|
      FinancialReason.find_or_create_by!(r.merge({financial_reason_type: bonus_type}))
    end

  end
end
