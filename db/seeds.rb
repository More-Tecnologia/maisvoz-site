ActiveRecord::Base.transaction do
  careers = [{name: 'Partner',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/partner.png',
              requalification_score: -1,
              maximum_qualifying_score: 0 },
             {name: 'Member',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/member.png',
              requalification_score: 0,
              maximum_qualifying_score: 0 },
             {name: 'Manager',
              qualifying_score: 45_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/manager.png',
              maximum_qualifying_score: 15_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Executive',
              qualifying_score: 105_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/executive.png',
              requalification_score: 0,
              maximum_qualifying_score: 35_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Director',
              qualifying_score: 300_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/director.png',
              requalification_score: 0,
              maximum_qualifying_score: 100_000,
              unilevel_qualifying_career_count: 3},
             {name: 'President',
              qualifying_score: 510_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/president.png',
              requalification_score: 0,
              maximum_qualifying_score: 170_000,
              unilevel_qualifying_career_count: 3},
             {name: 'Chairman',
              qualifying_score: 900_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman.png',
              requalification_score: 0,
              maximum_qualifying_score: 300_000,
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
  { name: 'Deposit', price: 1, binary_score: 1, active: true, virtual: true, kind: :deposit,
    category: deposit_cat, system_taxable: true, generate_pool_points: false }
deposit_product = Product.create!(deposit_attributes)

trails  = [{ name: 'Partner', product: deposit_product }]
persisted_trails = trails.map do |trail|
  Trail.create!(trail)
end

persisted_careers.each do |career|
  persisted_trails.each do |trail|
    maximum_binary_scores = { 'Partner': 0,
                             'Member': 10_000,
                             'Manager': 13_000,
                             'Executive': 18_000,
                             'Director': 25_000,
                             'President': 35_000,
                             'Chairman': 50_000 }.stringify_keys
    CareerTrail.find_or_create_by!(career: career,
                                   trail: trail,
                                   maximum_binary_score: maximum_binary_scores[career.name])
  end
end

# SCORE TYPES
score_types = [{ name: 'Membership Score', code: '100', active: false },
               { name: 'Activation Score', code: '200', active: false },
               { name: 'Shopping Score', code: '300', active: false },
               { name: 'Points Qualifications', code: '1000', active: true },
               { name: 'Inactivity Score Chargeback', code: '800', active: false },
               { name: 'Points Commissions', tree_type: :binary, code: '400', active: true },
               { name: 'Disqualification Binary Score Chargeback', tree_type: :binary, code: '500', active: false },
               { name: 'Inactivity Binary Score Chargeback', tree_type: :binary, code: '600', active: false },
               { name: 'Points Commissions Debit', tree_type: :binary, code: '700', active: true },
               { name: 'Pool Cash', code: '900', active: true }]
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
administrative_type = FinancialReasonType.find_or_create_by!(name: 'Financial administration', code: '100')
administrative_reasons = [{ title: 'System Fee', code: '200', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                          { title: 'Withdrawal', code: '300', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                          { title: 'Withdrawal Fee', code: '400', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                          { title: 'Order Payment', code: '1200', company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Credit', code: '2800', company_moneyflow: :debit, morenwm_moneyflow: :credit },
                          { title: 'Debit', code: '2900', company_moneyflow: :credit, morenwm_moneyflow: :debit },
                          { title: 'Expense', code: '3800', company_moneyflow: :debit, morenwm_moneyflow: :debit }]
administrative_reasons.each do |attributes|
  financial_reason = FinancialReason.find_by(code: attributes[:code])
  if financial_reason
    financial_reason.update_attributes(attributes)
  else
    FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: administrative_type}))
  end
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
                       email: 'systemxcapital@xcapital.com')
 more_user.save(validate: false) unless User.exists?(username: ENV['MORENWM_USERNAME'])

 admin_user = User.create!(username: ENV['MORENWM_CUSTOMER_ADMIN'],
                           name: ENV['MORENWM_CUSTOMER_ADMIN'],
                           role: 'admin',
                           password: '111111',
                           email: 'adminxcapital@xcapital.com',
                           sponsor: more_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_ADMIN'])

  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
               name: ENV['MORENWM_CUSTOMER_USERNAME'],
               role: 'empreendedor',
               password: '111111',
               email: 'xcapital@xcapital.com',
               sponsor: admin_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_USERNAME'])

 adminfinancial_user = User.create!(username: 'adminfinancial',
                                    name: 'Admin Financial',
                                    role: :financeiro,
                                    password: '111111',
                                    email: 'adminfinancial@xcapital.com',
                                    sponsor: admin_user)

support_user = User.create!(username: 'adminsupport',
                            name: 'Admin Support',
                            role: :suporte,
                            password: '111111',
                            email: 'adminsupport@xcapital.com',
                            sponsor: adminfinancial_user)

end

chargebacks = [['2100', '2000'], ['2300', '2200'], ['2500', '2400'], ['2700', '2600'], ['3000', '1400'], ['3200', '3100']]
chargebacks.each do |chargeback|
  chargeback_reason = FinancialReason.find_by(code: chargeback[0])
  chargeback_reason.update(financial_reason: FinancialReason.find_by(code: chargeback[1]))
end
