ActiveRecord::Base.transaction do
  careers = [{name: 'Member',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/member.png',
              requalification_score: -1,
              maximum_qualifying_score: 0 },
             {name: 'Partner',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/partner.png',
              requalification_score: -1,
              maximum_qualifying_score: 0 },
             {name: 'Clicker Star',
              qualifying_score: 500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/star.png',
              requalification_score: 0,
              maximum_qualifying_score: 0 },
             {name: 'Clicker Elite',
              qualifying_score: 800,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/elite.png',
              requalification_score: 0,
              maximum_qualifying_score: 0 },
             {name: 'Clicker Premium',
              qualifying_score: 100_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/premium.png',
              requalification_score: 0,
              maximum_qualifying_score: 25_000 },
             {name: 'Clicker Diamond',
              qualifying_score: 200_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/diamond.png',
              requalification_score: 0,
              maximum_qualifying_score: 40_000 },
             {name: 'Clicker Black',
              qualifying_score: 600_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/black.png',
              requalification_score: 0,
              maximum_qualifying_score: 100_000 },
             {name: 'Clicker Imperial',
              qualifying_score: 1_000_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/imperial.png',
              requalification_score: 0,
              maximum_qualifying_score: 125_000 },
             {name: 'Clicker Chairmain',
              qualifying_score: 2_250_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/chairman.png',
              requalification_score: 0,
              maximum_qualifying_score: 255_000 }]
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
deposit_attributes = [{ name: 'Click 20',
                        price: 20,
                        binary_score: 20,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 50',
                        price: 50,
                        binary_score: 50,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 100',
                        price: 100,
                        binary_score: 100,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 200',
                        price: 200,
                        binary_score: 200,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 400',
                        price: 400,
                        binary_score: 400,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 800',
                        price: 800,
                        binary_score: 800,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false },
                      { name: 'Click 1500',
                        price: 1500,
                        binary_score: 1500,
                        active: true,
                        virtual: true,
                        kind: :deposit,
                        category: deposit_cat,
                        system_taxable: false,
                        generate_pool_points: false }]
deposit_attributes.each do |attributes|
  product = Product.find_by(name: attributes[:name])
  product ? product.update!(attributes) : Product.create!(attributes)
end

persisted_trails = deposit_attributes.map do |attributes|
  product = Product.find_by(name: attributes[:name])

  Trail.create!(name: attributes[:name], product: product)
end

persisted_careers.each do |career|
  persisted_trails.each do |trail|
    CareerTrail.find_or_create_by!(career: career,
                                   trail: trail)
  end
end

type_attributes = [{ name: 'Member',
                     indications_quantity: 0,
                     bonus_percentage: 0,
                     qualify_by_user_activity: false,
                     withdrawal_minimum: 0,
                     withdrawal_in_percent: false },
                   { name: 'Click',
                     indications_quantity: 0,
                     bonus_percentage: 1.5,
                     qualify_by_user_activity: true,
                     withdrawal_minimum: 33,
                     withdrawal_in_percent: true },
                   { name: 'Basic',
                     indications_quantity: 2,
                     bonus_percentage: 2,
                     qualify_by_user_activity: true,
                     withdrawal_minimum: 20,
                     withdrawal_in_percent: true },
                   { name: 'Executive',
                     indications_quantity: 5,
                     bonus_percentage: 3,
                     qualify_by_user_activity: true,
                     withdrawal_minimum: 10,
                     withdrawal_in_percent: false }]
type_attributes.each do |attributes|
  type = Type.find_by(attributes.slice(:name))
  type ? type.update!(attributes) : Type.create!(type_attributes)
end


# SCORE TYPES
score_types = [{ name: 'Membership Score', code: '100', active: false },
               { name: 'Activation Score', code: '200', active: false },
               { name: 'Shopping Score', code: '300', active: false },
               { name: 'Points Qualifications', code: '1000', active: false },
               { name: 'Inactivity Score Chargeback', code: '800', active: false },
               { name: 'Points Commissions', tree_type: :binary, code: '400', active: false },
               { name: 'Disqualification Binary Score Chargeback', tree_type: :binary, code: '500', active: false },
               { name: 'Inactivity Binary Score Chargeback', tree_type: :binary, code: '600', active: false },
               { name: 'Points Commissions Debit', tree_type: :binary, code: '700', active: false },
               { name: 'Pool Cash', code: '900', active: false }]
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
                          { title: 'Expense', code: '3800', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                          { title: 'Order Sponsored', code: '4100', company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Deposit Less Than 50', code: '4200', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Loan Payment', code: '4300', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Third Party Order Payment', code: '4400', active: true, company_moneyflow: :not_applicable, morenwm_moneyflow: :not_applicable },
                          { title: 'Balance Transference', code: '4500', active: true, company_moneyflow: :not_applicable, morenwm_moneyflow: :not_applicable },
                          { title: 'Balance Transference Fee', code: '4600', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable }]
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
                   { title: 'Binary Bonus', code: '500', active: false, company_moneyflow: :debit   },
                   { title: 'Binary Bonus Chargeback for Inactivity', code: '600', active: false, company_moneyflow: :credit  },
                   { title: 'Binary Bonus Chargeback for Monthly Excess', code: '700', active: false, company_moneyflow: :credit  },
                   { title: 'Weekly Excess Binary Bonus Chargeback', code: '800', active: false, company_moneyflow: :credit  },
                   { title: 'Career Limit Bonus Chargeback', code: '900', active: false, company_moneyflow: :credit  },
                   { title: 'Referral Bonus', code: '1000', active: false, company_moneyflow: :debit },
                   { title: 'Bônus Clickcach', code: '1100', active: true, company_moneyflow: :debit },
                   { title: 'Binary Bonus Chargeback by Disqualification', code: '1300', active: false, company_moneyflow: :credit },
                   { title: 'Residual Support Point Bonus', code: '1400', active: false, company_moneyflow: :debit },
                   { title: 'Residual Support Point Inactivity Bonus Chargeback', code: '3000', active: false, company_moneyflow: :credit},
                   { title: 'Direct Referral Bonus', code: '2000', active: true, company_moneyflow: :debit  },
                   { title: 'Chargeback Direct Referral Bonus By Inactivity', code: '2100', active: true, company_moneyflow: :credit },
                   { title: 'Indirect Referral Bonus', code: '2200', dynamic_compression: true, active: true, company_moneyflow: :debit },
                   { title: 'Chargeback Indirect Referral Bonus By Inactivity', code: '2300', active: true, company_moneyflow: :credit },
                   { title: 'Activation Bonus', code: '2400', dynamic_compression: true, active: false, company_moneyflow: :debit },
                   { title: 'Inactivity Activation Bonus Chargeback', code: '2500', active: false, company_moneyflow: :credit },
                   { title: 'Residual Bonus', code: '2600', dynamic_compression: false, active: false, company_moneyflow: :debit },
                   { title: 'Residual Bonus Chargeback for Inactivity', code: '2700', active: false, company_moneyflow: :credit },
                   { title: 'Support Point Activation Bonus', code: '3100', active: false, company_moneyflow: :debit },
                   { title: 'Bonus Chargeback Activation of Inactivity Support Point', code: '3200', active: false, company_moneyflow: :credit },
                   { title: 'Binary Bonus Chargeback for Daily Excess', code: '3300', active: false, company_moneyflow: :credit },
                   { title: 'Bonus Chargeback for Contract Limit', code: '3400', active: false, company_moneyflow: :credit },
                   { title: 'Pool Cash', code: '3500', active: false, company_moneyflow: :debit },
                   { title: 'Equilibrium Bonus', code: '3600', active: false, company_moneyflow: :debit },
                   { title: 'Equilibrium Bonus Chargeback by Inactivity', code: '3700', active: false, company_moneyflow: :credit },
                   { title: 'Pool Leadership', code: '3900', active: false, company_moneyflow: :credit },
                   { title: 'Pool Leadership Chargeback by Inactivity', code: '4000', active: false, company_moneyflow: :credit }]

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
                       email: 'systempublimoney@publimoney.net')
 more_user.save(validate: false) unless User.exists?(username: ENV['MORENWM_USERNAME'])

 admin_user = User.create!(username: ENV['MORENWM_CUSTOMER_ADMIN'],
                           name: ENV['MORENWM_CUSTOMER_ADMIN'],
                           role: 'admin',
                           password: '111111',
                           email: 'adminpublimoney@publimoney.net',
                           sponsor: more_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_ADMIN'])

  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
               name: ENV['MORENWM_CUSTOMER_USERNAME'],
               role: 'empreendedor',
               password: '111111',
               email: 'publimoney@publimoney.net',
               sponsor: admin_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_USERNAME'])

 adminfinancial_user = User.create!(username: 'adminfinancial',
                                    name: 'Admin Financial',
                                    role: :financeiro,
                                    password: '111111',
                                    email: 'financiero@publimoney.net',
                                    sponsor: admin_user)

 support_user = User.create!(username: 'adminsupport',
                             name: 'Admin Support',
                             role: :suporte,
                             password: '111111',
                             email: 'soporte@publimoney.net',
                             sponsor: adminfinancial_user)

 contact_user = User.create!(username: 'admincontacto',
                             name: 'Admin Contacto',
                             role: :suporte,
                             password: '111111',
                             email: 'contacto@publimoney.net',
                             sponsor: support_user)

  adminfinancial_user.binary_node.delete
  support_user.binary_node.delete
  contact_user.binary_node.delete
  admin_user.binary_node.update!(left_child_id: nil)

end

chargebacks = [['2100', '2000'], ['2300', '2200'], ['2500', '2400'], ['2700', '2600'], ['3000', '1400'], ['3200', '3100']]
chargebacks.each do |chargeback|
  chargeback_reason = FinancialReason.find_by(code: chargeback[0])
  chargeback_reason.update(financial_reason: FinancialReason.find_by(code: chargeback[1]))
end
