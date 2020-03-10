ActiveRecord::Base.transaction do
  careers = [{name: 'Partner',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/partner.png',
              requalification_score: -1},
             {name: 'Member',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/member.png',
              requalification_score: 0},
             {name: 'Manager',
              qualifying_score: 45_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager.png',
              lineage_score: 15_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Executive',
              qualifying_score: 105_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/executive.png',
              requalification_score: 0,
              lineage_score: 35_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Director',
              qualifying_score: 300_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/director.png',
              requalification_score: 0,
              lineage_score: 100_000,
              unilevel_qualifying_career_count: 3},
             {name: 'President',
              qualifying_score: 510_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/president.png',
              requalification_score: 0,
              lineage_score: 170_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Chairman',
              qualifying_score: 900_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman.png',
              requalification_score: 0,
              lineage_score: 300_000,
              unilevel_qualifying_career_count: 3}
            ]
persisted_careers = careers.map do |attributes|
  career = Career.find_by(name: attributes[:name])
  if career
    career.update_attributes(attributes)
    career
  else
    Career.find_or_create_by!(attributes)
  end
end

deposit_cat = Category.find_or_create_by(name: 'Deposit')
deposit_attributes =
  { name: 'Deposit', price: 1, binary_score: 0, active: true, virtual: true, kind: :deposit, category: deposit_cat }
deposit_product = Product.create!(deposit_attributes)

trails  = [{ name: 'Partner', product: deposit_product }]
persisted_trails = trails.map do |trail|
  Trail.create!(trail)
end

persisted_careers.each do |career|
  persisted_trails.each do |trail|
    maximum_bonus = { 'Partner': 0,
                      'Member': 0,
                      'Manager': 2_000,
                      'Executive': 2_000,
                      'Director': 3_000,
                      'President': 5_000,
                      'Chairman': 10_000 }.stringify_keys
    CareerTrail.find_or_create_by!(career: career,
                                   trail: trail,
                                   maximum_bonus: maximum_bonus[career.name])
  end
end

# SCORE TYPES
score_types = [{ name: 'Pontuação de Adesões', code: '100', active: false },
               { name: 'Pontuação de Ativação', code: '200', active: false },
               { name: 'Pontuação de Compras', code: '300', active: false },
               { name: 'Estorno de Pontuação por Inatividade', code: '800', active: false },
               { name: 'Points Commissions', tree_type: :binary, code: '400', active: true },
               { name: 'Estorno de Pontuação Binária por Desqualificação', tree_type: :binary, code: '500', active: false },
               { name: 'Estorno de Pontuação Binária por Inatividade', tree_type: :binary, code: '600', active: false },
               { name: 'Points Commissions Debit', tree_type: :binary, code: '700', active: true },
               { name: 'Pool Point', code: '900', active: true }]
score_types.each do |score_type|
  score = ScoreType.find_by(code: score_type[:code])
  if score
    score.update_attributes(score_type)
    score
  else
    ScoreType.create!(score_type)
  end
end


# FINANCIAL REASONS
administrative_type = FinancialReasonType.find_or_create_by!(name: 'Administrativo Financeiro', code: '100')
administrative_reasons = [{ title: 'Taxa do Sistema', code: '200', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                          { title: 'Withdrawal', code: '300', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                          { title: 'Withdrawal Fee', code: '400', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                          { title: 'Order Payment', code: '1200', company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Credit', code: '2800', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                          { title: 'Debit', code: '2900', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                          { title: 'Despesa', code: '3800', company_moneyflow: :debit, morenwm_moneyflow: :debit }]
administrative_reasons.each do |attributes|
  financial_reason = FinancialReason.find_by(code: attributes[:code])
  if financial_reason
    financial_reason.update_attributes(attributes)
  else
    FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: administrative_type}))
  end
end

  bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
  bonus_reasons = [{ title: 'Estorno de Bonus', code: '100', active: false, company_moneyflow: :credit },
                   { title: 'Binary Bonus', code: '500', active: true, company_moneyflow: :debit   },
                   { title: 'Binary Bonus Chargeback for Inactivity', code: '600', active: true, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus Binário por Excesso Mensal', code: '700', active: false, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus Binário por Excesso Semanal', code: '800', active: false, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus por Limite de Carreira', code: '900', active: false, company_moneyflow: :credit  },
                   { title: 'Bonus Indicacao', code: '1000', active: false, company_moneyflow: :debit },
                   { title: 'Bonus Rendimento', code: '1100', active: false, company_moneyflow: :debit },
                   { title: 'Binary Bonus Chargeback por Desqualificação', code: '1300', active: true, company_moneyflow: :credit },
                   { title: 'Bônus Residual de Ponto de Apoio', code: '1400', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Residual de Ponto de Apoio por Inatividade', code: '3000', active: false, company_moneyflow: :credit},
                   { title: 'Start Fast Bonus', code: '2000', active: true, company_moneyflow: :debit  },
                   { title: 'Chargeback Start Fast Bonus for Inactivity', code: '2100', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Indicação Indireta', code: '2200', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Indicação Indireta por Inatividade', code: '2300', active: false, company_moneyflow: :credit },
                   { title: 'Bonus Ativação', code: '2400', dynamic_compression: true, active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Ativação por Inatividade', code: '2500', active: false, company_moneyflow: :credit },
                   { title: 'Residual Bonus', code: '2600', dynamic_compression: false, active: true, company_moneyflow: :debit },
                   { title: 'Residual Bonus Chargeback for Inactivity', code: '2700', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Ativação de Ponto de Apoio', code: '3100', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bonus Ativação de Ponto de Apoio por Inatividade', code: '3200', active: false, company_moneyflow: :credit },
                   { title: 'Binary Bonus Chargeback for Daily Excess', code: '3300', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Chargeback for Contract Limit', code: '3400', active: true, company_moneyflow: :credit },
                   { title: 'Pool Tranding', code: '3500', active: true, company_moneyflow: :debit },
                   { title: 'Equilibrium Bonus', code: '3600', active: true, company_moneyflow: :debit },
                   { title: 'Equilibrium Bonus Chargeback by Inactivity', code: '3700', active: true, company_moneyflow: :credit },
                   { title: 'Pool Leadership', code: '3900', active: true, company_moneyflow: :credit },
                   { title: 'Pool Leadership Chargeback by Inactivity', code: '4000', active: true, company_moneyflow: :credit }]

  bonus_reasons.each do |attributes|
    financial_reason = FinancialReason.find_by(code: attributes[:code])
    if financial_reason
      financial_reason.update_attributes(attributes)
    else
      FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: bonus_type}))
    end
  end

  # USERS
  more_user = User.new(username: ENV['MORENWM_USERNAME'],
                       name: ENV['MORENWM_USERNAME'],
                       role: 'admin',
                       password: '111111',
                       email: 'morenwm@morenwm.com')
 more_user.save(validate: false) unless User.exists?(username: ENV['MORENWM_USERNAME'])

 admin_user = User.create!(username: ENV['MORENWM_CUSTOMER_ADMIN'],
                           name: ENV['MORENWM_CUSTOMER_ADMIN'],
                           role: 'admin',
                           password: '111111',
                           email: 'admin@morenwm.com',
                           sponsor: more_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_ADMIN'])

  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
               name: ENV['MORENWM_CUSTOMER_USERNAME'],
               role: 'empreendedor',
               password: '111111',
               email: 'customer-morenwm@morenwm.com',
               sponsor: admin_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_USERNAME'])

end

chargebacks = [['2100', '2000'], ['2300', '2200'], ['2500', '2400'], ['2700', '2600'], ['3000', '1400'], ['3200', '3100']]
chargebacks.each do |chargeback|
  chargeback_reason = FinancialReason.find_by(code: chargeback[0])
  chargeback_reason.update(financial_reason: FinancialReason.find_by(code: chargeback[1]))
end
