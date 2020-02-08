# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  career2 = Career.find_by(name: 'Member')
  career2.update_attribute(:qualifying_score, 2)
  careers = [{name: 'Partner',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/partner.png',
              requalification_score: -1 },
             {name: 'Member',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/member.png',
              requalification_score: 0},
             {name: 'Manager',
              qualifying_score: 10_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager.png'},
             {name: 'Manager 25K',
              qualifying_score: 25_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager-25k.png',
              requalification_score: 0},
             {name: 'Manager 50K',
              qualifying_score: 50_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager-50K.png',
              requalification_score: 0},
             {name: 'Manager 100K',
              qualifying_score: 100_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager-100K.png',
              requalification_score: 0},
             {name: 'Director 250K',
              qualifying_score: 250_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/director-250k.png',
              requalification_score: 0},
             {name: 'Director 500K',
              qualifying_score: 500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/director-500.png',
              requalification_score: 0},
             {name: 'Milionaire 1M',
              qualifying_score: 1_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/milionaire-1m.png',
              requalification_score: 0},
             {name: 'Milionaire 2.5M',
              qualifying_score: 2_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/milionaire-25.png',
              requalification_score: 0},
             {name: 'Milionaire 5M',
              qualifying_score: 5_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/milionaire-5m.png',
              requalification_score: 0},
             {name: 'Chairman 10M',
              qualifying_score: 10_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman-10m.png',
              requalification_score: 0},
             {name: 'Chairman 25M',
              qualifying_score: 25_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman-25m.png',
              requalification_score: 0},
             {name: 'Chairman 50M',
              qualifying_score: 50_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman-50m.png',
              requalification_score: 0}
            ]
persisted_careers = careers.map do |attributes|
  career = Career.find_by(name: attributes[:name])
  if career
    career.update_attributes(attributes.except(:qualifying_score, :requalification_score))
    career
  else
    Career.find_or_create_by!(attributes.except(:qualifying_score, :requalification_score))
  end
end

trail1 = Trail.find_by(name: 'Trilha 1')
trail1.update_attributes(name: 'Basic', product: Product.find(5)) if trail1

trails  = [{ name: 'Vision', product: Product.find(6) },
           { name: 'Advance', product: Product.find(7) }]
persisted_trails = trails.map do |trail|
  trail = Trail.find_or_create_by!(trail)
end
persisted_trails = [trail1] + persisted_trails if trail1

persisted_careers.each do |career|
  persisted_trails.each do |trail|
    CareerTrail.find_or_create_by!(career: career, trail: trail)
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
administrative_reasons = [{ title: 'Taxa do Sistema', code: '200', company_moneyflow: :debit },
                          { title: 'Withdrawal', code: '300', company_moneyflow: :debit },
                          { title: 'Withdrawal Fee', code: '400', company_moneyflow: :credit },
                          { title: 'Order Payment', code: '1200', company_moneyflow: :credit },
                          { title: 'Credit', code: '2800', company_moneyflow: :debit },
                          { title: 'Debit', code: '2900', company_moneyflow: :credit }]
administrative_reasons.each do |attributes|
  financial_reason = FinancialReason.find_by(code: attributes[:code])
  if financial_reason
    financial_reason.update_attributes(attributes)
  else
    FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: administrative_type}))
  end
end

  bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
  bonus_reasons = [{ title: 'Estorno de Bonus', code: '100', active: false, company_moneyflow: :credit, active: false },
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
                   { title: 'Direct Commission Bonus', code: '2000', active: true, company_moneyflow: :debit  },
                   { title: 'Chargeback Direct Commission Bonus for Inactivity', code: '2100', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Indicação Indireta', code: '2200', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Indicação Indireta por Inatividade', code: '2300', active: false, company_moneyflow: :credit },
                   { title: 'Bonus Ativação', code: '2400', dynamic_compression: true, active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Ativação por Inatividade', code: '2500', active: false, company_moneyflow: :credit },
                   { title: 'Bonus Residual', code: '2600', dynamic_compression: true, active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Residual por Inatividade', code: '2700', active: false, company_moneyflow: :credit },
                   { title: 'Bonus Ativação de Ponto de Apoio', code: '3100', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bonus Ativação de Ponto de Apoio por Inatividade', code: '3200', active: false, company_moneyflow: :credit },
                   { title: 'Binary Bonus Chargeback for Daily Excess', code: '3300', active: true, company_moneyflow: :credit }]

  bonus_reasons.each do |attributes|
    financial_reason = FinancialReason.find_by(code: attributes[:code])
    if financial_reason
      financial_reason.update_attributes(attributes)
    else
      FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: bonus_type}))
    end
  end

  # USERS
 #  more_user = User.new(username: ENV['MORENWM_USERNAME'],
 #                       name: ENV['MORENWM_USERNAME'],
 #                       role: 'admin',
 #                       password: '111111',
 #                       email: 'morenwm@morenwm.com')
 # more_user.save(validate: false) unless User.exists?(username: ENV['MORENWM_USERNAME'])
 #
 # admin_user = User.create!(username: ENV['MORENWM_CUSTOMER_ADMIN'],
 #                           name: ENV['MORENWM_CUSTOMER_ADMIN'],
 #                           role: 'admin',
 #                           password: '111111',
 #                           email: 'admin@morenwm.com',
 #                           sponsor: more_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_ADMIN'])
 #
 #  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
 #               name: ENV['MORENWM_CUSTOMER_USERNAME'],
 #               role: 'empreendedor',
 #               password: '111111',
 #               email: 'customer-morenwm@morenwm.com',
 #               sponsor: admin_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_USERNAME'])

end

chargebacks = [['2100', '2000'], ['2300', '2200'], ['2500', '2400'], ['2700', '2600'], ['3000', '1400'], ['3200', '3100']]
chargebacks.each do |chargeback|
  chargeback_reason = FinancialReason.find_by(code: chargeback[0])
  chargeback_reason.update(financial_reason: FinancialReason.find_by(code: chargeback[1]))
end

sistem_fee = FinancialReason.morenwm_fee
sistem_fee.financial_transactions.update_all(moneyflow: 1)

advance_product = Product.find_by(name: 'Advance')
advance_product.update!(code: 20)
