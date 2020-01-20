# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  c = CareerTrail.where(career_id: 2).delete_all
  c = Career.where(id: 2).delete_all
  c = Career.find_by(name: 'Consultor Premium')
  c.update_attribute(:name, 'Consultor')

  careers = [{name: 'Inscrito',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inscrito.png',
              requalification_score: -1,
              unilevel_qualifying_career_count: 0 },
             {name: 'Consultor',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/consultor.png',
              requalification_score: 0},
             {name: 'Executivo Bronze',
              qualifying_score: 3_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/bronze.png',
              requalification_score: 350,
              unilevel_qualifying_career_count: 2},
             {name: 'Executivo Prata',
              qualifying_score: 10_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/prata.png',
              requalification_score: 1050,
              unilevel_qualifying_career_count: 2},
             {name: 'Executivo Ouro',
              qualifying_score: 52_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/ouro.png',
              requalification_score: 5250,
              unilevel_qualifying_career_count: 5,
              lineage_score: 10500},
             {name: 'Executivo Rubi',
              qualifying_score: 175_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/rubi.png',
              requalification_score: 17_500,
              unilevel_qualifying_career_count: 7,
              lineage_score: 25000},
             {name: 'Executivo Esmeralda',
              qualifying_score: 350_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/esmeralda.png',
              requalification_score: 35_000,
              unilevel_qualifying_career_count: 7,
              lineage_score: 50000},
             {name: 'Diamante',
              qualifying_score: 1_750_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/diamante.png',
              requalification_score: 175_000,
              unilevel_qualifying_career_count: 8,
              lineage_score: 218750},
             {name: 'Diamante Azul',
              qualifying_score: 3_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/diamante-azul.png',
              requalification_score: 350_000,
              unilevel_qualifying_career_count: 8,
              lineage_score: 437500},
             {name: 'Diamante Negro',
              qualifying_score: 10_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/diamante-negro.png',
              requalification_score: 1_050_000,
              unilevel_qualifying_career_count: 9,
              lineage_score: 1166666},
             {name: 'Presidente',
              qualifying_score: 17_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/presidente.png',
              requalification_score: 1_750_000,
              unilevel_qualifying_career_count: 10,
              lineage_score: 1_750_000}
            ]
  persisted_careers = careers.map do |attributes|
    career = Career.find_by(name: attributes[:name])
    if career
      career.update_attributes(attributes.except(:qualifying_score, :requalification_score))
    else
      Career.find_or_create_by(attributes.except(:qualifying_score, :requalification_score))
    end
  end

  # adhesion_category = Category.find_or_create_by!(name: '+ Voz Pack',
  #                                                 active_session: true,
  #                                                 active: true)

  sim_card_category = Category.find_or_create_by!(name: 'CHIPs',
                                                  active_session: true,
                                                  active: true,
                                                  code: 10)

  cellphone_reload_category = Category.find_or_create_by!(name: 'Recargas',
                                                          active_session: false,
                                                          active: false,
                                                          code: 11)

  sim_card = Product.find_or_create_by!(name: 'Pacote de CHIPs',
                                        quantity: 10,
                                        price_cents: 9990,
                                        binary_score: 0,
                                        binary_bonus: 0,
                                        active: true,
                                        virtual: false,
                                        category: sim_card_category,
                                        paid_by: :paid_by_user,
                                        kind: :detached,
                                        maturity_days: nil,
                                        grace_period: 0)

elite_product_bonus = Product.find_or_create_by!(name: 'Pacote de CHIPs - Bonus Elite',
                                                 quantity: 1,
                                                 price_cents: 0,
                                                 binary_score: 0,
                                                 binary_bonus: 0,
                                                 active: false,
                                                 virtual: false,
                                                 category: sim_card_category,
                                                 paid_by: :paid_by_user,
                                                 kind: :detached,
                                                 maturity_days: nil,
                                                 grace_period: 0)

premium_product_bonus = Product.find_or_create_by!(name: 'Pacote de CHIPs - Bonus Premium',
                                                   quantity: 3,
                                                   price_cents: 0,
                                                   binary_score: 0,
                                                   binary_bonus: 0,
                                                   active: false,
                                                   virtual: false,
                                                   category: sim_card_category,
                                                   paid_by: :paid_by_user,
                                                   kind: :detached,
                                                   maturity_days: nil,
                                                   grace_period: 0)

  _99_product = Product.find_or_create_by!(name: 'Recarga de Ativação R$ 99,90',
                                           quantity: 1,
                                           price_cents: 9990,
                                           binary_score: 50,
                                           binary_bonus: 0,
                                           active: false,
                                           virtual: true,
                                           category: cellphone_reload_category,
                                           paid_by: :paid_by_user,
                                           kind: :activation,
                                           code: 20)

 _129_product = Product.find_or_create_by!(name: 'Recarga de Ativação R$ 129,90',
                                           quantity: 1,
                                           price_cents: 12990,
                                           binary_score: 65,
                                           binary_bonus: 0,
                                           active: false,
                                           virtual: true,
                                           category: cellphone_reload_category,
                                           paid_by: :paid_by_user,
                                           kind: :activation,
                                           code: 21)

  _149_product = Product.find_or_create_by!(name: 'Recarga de Ativação R$ 149,90',
                                            quantity: 1,
                                            price_cents: 14990,
                                            binary_score: 75,
                                            binary_bonus: 0,
                                            active: false,
                                            virtual: true,
                                            category: cellphone_reload_category,
                                            paid_by: :paid_by_user,
                                            kind: :activation,
                                            code: 22)

 # elite = Product.find_or_create_by!(name: '+ Voz Elite',
 #                                    quantity: 1,
 #                                    price_cents: 34999,
 #                                    binary_score: 175,
 #                                    binary_bonus: 0,
 #                                    active: true,
 #                                    virtual: true,
 #                                    category: adhesion_category,
 #                                    paid_by: :paid_by_user,
 #                                    kind: :adhesion)
 #
 # premium = Product.find_or_create_by!(name: '+ Voz Premium',
 #                                      quantity: 1,
 #                                      price_cents: 69999,
 #                                      binary_score: 350,
 #                                      binary_bonus: 0,
 #                                      active: true,
 #                                      virtual: true,
 #                                      category: adhesion_category,
 #                                      paid_by: :paid_by_user,
 #                                      kind: :adhesion)

reload_34_99 = Product.find_or_create_by!(name: 'Recarga 34,90',
                                         quantity: 1,
                                         price_cents: 3499,
                                         binary_score: 0,
                                         binary_bonus: 0,
                                         active: false,
                                         virtual: false,
                                         category: cellphone_reload_category,
                                         paid_by: :paid_by_user,
                                         kind: :detached,
                                         binary_score: 15)

reload_44_99 = Product.find_or_create_by!(name: 'Recarga 44,90',
                                          quantity: 1,
                                          price_cents: 4499,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached,
                                          binary_score: 20)

reload_69_90 = Product.find_or_create_by!(name: 'Recarga 69,90',
                                          quantity: 1,
                                          price_cents: 6990,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached,
                                          binary_score: 30)

reload_99_99 = Product.find_or_create_by!(name: 'Recarga 99,90',
                                          quantity: 1,
                                          price_cents: 9999,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached,
                                          binary_score: 45)

# TRAILS
# trails  = [{ name: 'Elite', product: elite, product_bonus: elite_product_bonus },
#            { name: 'Premium', product: premium, product_bonus: premium_product_bonus }]
# persisted_trails = trails.map { |trail| Trail.find_or_create_by!(trail) }
#
#   persisted_careers.each do |career|
#     persisted_trails.each do |trail|
#       CareerTrail.find_or_create_by!(career: career, trail: trail)
#     end
#   end

  career_trails = CareerTrail.includes(:career, :trail).all
  career_trails.each do |c|
    activation_product_codes = c.career.qualifying_score < 52_500 ? [20, 21, 22] : [22]
    c.update_attributes!(activation_product_codes: activation_product_codes)
  end

  # SCORE TYPES
  score_types = [{ name: 'Pontuação de Adesões', code: '100' },
                 { name: 'Pontuação de Ativação', code: '200' },
                 { name: 'Pontuação de Compras', code: '300' },
                 { name: 'Estorno de Pontuação por Inatividade', code: '800' },
                 { name: 'Pontuação Binária', tree_type: :binary, code: '400', active: false },
                 { name: 'Estorno de Pontuação Binária por Desqualificação', tree_type: :binary, code: '500', active: false },
                 { name: 'Estorno de Pontuação Binária por Inatividade', tree_type: :binary, code: '600', active: false },
                 { name: 'Débito de Bonus Binário', tree_type: :binary, code: '700', active: false }]
  score_types.each { |score_type| ScoreType.find_or_create_by!(score_type) unless ScoreType.exists?(code: score_type[:code]) }


  # FINANCIAL REASONS
  administrative_type = FinancialReasonType.find_or_create_by!(name: 'Administrativo Financeiro', code: '100')
  administrative_reasons = [{ title: 'Taxa do Sistema', code: '200', company_moneyflow: :debit },
                            { title: 'Saque', code: '300', company_moneyflow: :debit },
                            { title: 'Taxa de Saque', code: '400', company_moneyflow: :credit },
                            { title: 'Pagamento de Pedido', code: '1200', company_moneyflow: :credit },
                            { title: 'Credito', code: '2800', company_moneyflow: :debit },
                            { title: 'Debito', code: '2900', company_moneyflow: :credit }]
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
                   { title: 'Bonus Binário', code: '500', active: false, company_moneyflow: :debit   },
                   { title: 'Estorno de Bonus Binário por Inatividade', code: '600', active: false, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus Binário por Excesso Mensal', code: '700', active: false, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus Binário por Excesso Semanal', code: '800', active: false, company_moneyflow: :credit  },
                   { title: 'Estorno de Bonus por Limite de Careeira', code: '900', active: false, company_moneyflow: :credit  },
                   { title: 'Bonus Indicacao', code: '1000', active: false, company_moneyflow: :debit },
                   { title: 'Bonus Rendimento', code: '1100', active: false, company_moneyflow: :debit },
                   { title: 'Estorno de Bonus Binário por Desqualificação', code: '1300', active: false, company_moneyflow: :credit  },
                   { title: 'Bônus Residual de Ponto de Apoio', code: '1400', active: true, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Residual de Ponto de Apoio por Inatividade', code: '3000', active: true, company_moneyflow: :credit},
                   { title: 'Bonus Indicação Direta', code: '2000', active: true, company_moneyflow: :debit  },
                   { title: 'Estorno de Bônus Indicação Direta por Inatividade', code: '2100', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Indicação Indireta', code: '2200', active: true, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Indicação Indireta por Inatividade', code: '2300', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Ativação', code: '2400', dynamic_compression: true, active: true, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Ativação por Inatividade', code: '2500', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Residual', code: '2600', dynamic_compression: true, active: true, company_moneyflow: :debit },
                   { title: 'Estorno de Bônus Residual por Inatividade', code: '2700', active: true, company_moneyflow: :credit },
                   { title: 'Bonus Ativação de Ponto de Apoio', code: '3100', active: true, company_moneyflow: :debit },
                   { title: 'Estorno de Bonus Ativação de Ponto de Apoio por Inatividade', code: '3200', active: true, company_moneyflow: :credit }]

  bonus_reasons.each do |attributes|
    financial_reason = FinancialReason.find_by(code: attributes[:code])
    if financial_reason
      financial_reason.update_attributes(attributes)
    else
      FinancialReason.find_or_create_by!(attributes.merge({financial_reason_type: bonus_type}))
    end
  end

  # RoleTypes
  role_types = [{ name: 'Ponto de Apoio', code: 10 }]
  role_types.each { |role_type| RoleType.find_or_create_by(role_type) }

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

careers = Career.where('qualifying_score > 0')
consultant = Career.find_by(name: 'Consultor')
careers.each do |career|
  career.update_attribute(:unilevel_qualifying_career, consultant)
end

products = Product.where(name: ['+ Voz Elite', '+ Voz Premium'])
products.update_all(active: true)

sistem_fee = FinancialReason.morenwm_fee
sistem_fee.financial_transactions.update_all(moneyflow: 1)
