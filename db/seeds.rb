ActiveRecord::Base.transaction do
  careers = [{name: 'Member',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/member.png',
              requalification_score: -1,
              maximum_qualifying_score: 0 }]
persisted_careers = careers.map do |attributes|
  career = Career.find_by(name: attributes[:name])
  if career
    career.update_attributes(attributes)
    career
  else
    Career.find_or_create_by!(attributes)
  end
end

attributes = [{ name: 'Financial', active: true },
              { name: 'Network', active: true },
              { name: 'Bonus Withdrawal', active: true },
              { name: 'Others', active: true },
              { name: 'Product Returns', active: true },
              { name: 'Faulty Products', active: true },
              { name: 'Purchase Cancellation', active: true },
              { name: 'Bonus Not Received', active: true },
              { name: 'Withdrawal Issues', active: true },
              { name: 'Complain About a Seller', active: true },
              { name: 'System Issues', active: true },
              { name: 'Account Approval', active: true },
              { name: 'Suggestions', active: true }]

Subject.create!(attributes)

Category.find_or_create_by(name: 'Course')
deposit_cat = Category.find_or_create_by(name: 'Deposit')
if ActiveModel::Type::Boolean.new.cast(ENV['ADMONEY'])
  deposit_attributes = [{ name: 'Adcash',
                          price_cents: 0,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :free,
                          category: deposit_cat,
                          system_taxable: false,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#EF539F',
                          task_per_day: 3,
                          earnings_per_campaign: 50 },
                        { name: 'Adcash 01',
                          price_cents: 24_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#FFA126',
                          task_per_day: 2,
                          earnings_per_campaign: 20,
                          code: 1 },
                        { name: 'Adcash 02',
                          price_cents: 50_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#5DE187',
                          task_per_day: 2,
                          earnings_per_campaign: 50,
                          code: 2 },
                        { name: 'Adcash 03',
                          price_cents: 100_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#3CC9A5',
                          task_per_day: 4,
                          earnings_per_campaign: 50,
                          code: 3 },
                        { name: 'Adcash 04',
                          price_cents: 240_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#8E89DA',
                          task_per_day: 5,
                          earnings_per_campaign: 100,
                          code: 4 },
                        { name: 'Adcash 05',
                          price_cents: 500_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#3FBDF4',
                          task_per_day: 10,
                          earnings_per_campaign: 100 },
                        { name: 'Adcash 06',
                          price_cents: 1_000_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#D92163',
                          task_per_day: 15,
                          earnings_per_campaign: 150 },
                        { name: 'Adcash 07',
                          price_cents: 1_500_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#FF5300',
                          task_per_day: 15,
                          earnings_per_campaign: 200 }]
else
  deposit_attributes = [{ name: 'Pack luck 1',
                          price_cents: 5_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#EF539F',
                          task_per_day: 0,
                          earnings_per_campaign: 0 },
                        { name: 'Pack luck 2',
                          price_cents: 10_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#FFA126',
                          task_per_day: 0,
                          earnings_per_campaign: 0 },
                        { name: 'Pack luck 3',
                          price_cents: 25_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#5DE187',
                          task_per_day: 1,
                          earnings_per_campaign: 50 },
                        { name: 'Pack luck 4',
                          price_cents: 50_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#3CC9A5',
                          task_per_day: 1,
                          earnings_per_campaign: 50 },
                        { name: 'Pack luck 5',
                          price_cents: 100_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#8E89DA',
                          task_per_day: 1,
                          earnings_per_campaign: 50 },
                        { name: 'Pack luck 6',
                          price_cents: 200_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#3FBDF4',
                          task_per_day: 1,
                          earnings_per_campaign: 100 },
                        { name: 'Pack luck 7',
                          price_cents: 500_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#D92163',
                          task_per_day: 1,
                          earnings_per_campaign: 125 },
                        { name: 'Pack luck 8',
                          price_cents: 1_000_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#FF5300',
                          task_per_day: 1,
                          earnings_per_campaign: 150 },
                          {name: 'Pack luck 9',
                          price_cents: 3_000_00,
                          binary_score: 0,
                          active: true,
                          virtual: true,
                          kind: :deposit,
                          category: deposit_cat,
                          system_taxable: true,
                          generate_pool_points: false,
                          quantity: 1,
                          details: '#FF5300',
                          task_per_day: 1,
                          earnings_per_campaign: 200 }]
end

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
                     bonus_percentage: 1,
                     qualify_by_user_activity: true,
                     withdrawal_minimum: 33,
                     withdrawal_in_percent: true },
                   { name: 'Basic',
                     indications_quantity: 2,
                     bonus_percentage: 1.5,
                     qualify_by_user_activity: true,
                     withdrawal_minimum: 20,
                     withdrawal_in_percent: true },
                   { name: 'Executive',
                     indications_quantity: 4,
                     bonus_percentage: 2,
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
               { name: 'Points Qualifications', code: '1000', active: true },
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
                          { title: 'Balance Transference Fee', code: '4600', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable },
                          { title: 'Payment with Balance', code: '4700', active: true, company_moneyflow: :credit, morenwm_moneyflow: :not_applicable},
                          { title: 'Pool Wallet Expense', code: '9999', company_moneyflow: :debit, morenwm_moneyflow: :debit },
                          { title: 'Payment with Promotional Balance', code: '7300', company_moneyflow: :not_applicable, morenwm_moneyflow: :not_applicable}]
administrative_reasons.each do |attributes|
  financial_reason = FinancialReason.find_by(code: attributes[:code])
  if financial_reason
    financial_reason.update_attributes(attributes)
  else
    FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: administrative_type}))
  end
end

bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
bonus_reasons = [{ title: 'Credit for payment by First Buy', code: '7500', dynamic_compression: false, active: true, company_moneyflow: :not_applicable } ]

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
                       email: 'systemclicktok@clicktok.io')
 more_user.save(validate: false) unless User.exists?(username: ENV['MORENWM_USERNAME'])

 admin_user = User.create!(username: ENV['MORENWM_CUSTOMER_ADMIN'],
                           name: ENV['MORENWM_CUSTOMER_ADMIN'],
                           role: 'admin',
                           password: '111111',
                           email: 'adminclicktok@clicktok.io',
                           sponsor: more_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_ADMIN'])

  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
               name: ENV['MORENWM_CUSTOMER_USERNAME'],
               role: 'empreendedor',
               password: '111111',
               email: 'clicktok@clicktok.io',
               sponsor: admin_user) unless User.exists?(username: ENV['MORENWM_CUSTOMER_USERNAME'])

 adminfinancial_user = User.create!(username: 'adminfinancial',
                                    name: 'Admin Financial',
                                    role: :financeiro,
                                    password: '111111',
                                    email: 'financiero@clicktok.io',
                                    sponsor: admin_user)

 support_user = User.create!(username: 'adminsupport',
                             name: 'Admin Support',
                             role: :suporte,
                             password: '111111',
                             email: 'soporte@clicktok.io',
                             sponsor: adminfinancial_user)

 contact_user = User.create!(username: 'admincontacto',
                             name: 'Admin Contacto',
                             role: :suporte,
                             password: '111111',
                             email: 'contacto@clicktok.io',
                             sponsor: support_user)

  adminfinancial_user.binary_node.delete
  support_user.binary_node.delete
  contact_user.binary_node.delete
  admin_user.binary_node.update!(left_child_id: nil)
end

chargebacks = [['2100', '2000'], ['2300', '2200'], ['2500', '2400'], ['2700', '2600'], ['3000', '1400'], ['3200', '3100'], ['3700', '3600']]
chargebacks.each do |chargeback|
  chargeback_reason = FinancialReason.find_by(code: chargeback[0])
  chargeback_reason.update(financial_reason: FinancialReason.find_by(code: chargeback[1]))
end

unless SystemConfiguration.active_config.present?
  SystemConfiguration.create(company_name: ENV['COMPANY_NAME'],
                             withdrawal_fee: ENV['WITHDRAWAL_FEE'],
                             taxable_fee: ENV['SYSTEM_FEE'])
end

BannerStore.find_or_create_by(title: 'Ads', active: true)

publicity_cat = Category.find_or_create_by(name: 'Publicity')
publicity_attributes = [{ name: 'Advestising Package',
                        price_cents: 25_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: false,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#EF539F',
                        task_per_day: 0,
                        clicks: 1_000 },
                      { name: 'Advestising Package +1',
                        price_cents: 50_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: true,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#FFA126',
                        task_per_day: 0,
                        clicks: 2_000 },
                      { name: 'Advestising Package +2',
                        price_cents: 100_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: true,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#5DE187',
                        task_per_day: 0,
                        clicks: 5_000 },
                      { name: 'Advestising Package +3',
                        price_cents: 300_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: true,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#3CC9A5',
                        task_per_day: 0,
                        clicks: 10_000 },
                      { name: 'Advestising Package +4',
                        price_cents: 600_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: true,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#8E89DA',
                        task_per_day: 0,
                        clicks: 30_000 },
                      { name: 'Advestising Package +5',
                        price_cents: 1_000_00,
                        binary_score: 0,
                        active: true,
                        virtual: true,
                        kind: :publicity,
                        category: publicity_cat,
                        system_taxable: true,
                        generate_pool_points: false,
                        quantity: 1,
                        details: '#3FBDF4',
                        task_per_day: 0,
                        clicks: 80_000 }]

publicity_attributes.each do |attributes|
  product = Product.find_by(name: attributes[:name])
  product ? product.update!(attributes) : Product.create!(attributes)
end

Category.find_or_create_by(name: 'Raffle')
