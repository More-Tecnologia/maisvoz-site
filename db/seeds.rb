# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  #CAREERS
  careers = [{name: 'Inscrito',
              qualifying_score: -1,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: -1 },
             {name: 'Consultor',
              qualifying_score: 0,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 0},
             {name: 'Executivo Bronze',
              qualifying_score: 3_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 350},
             {name: 'Executivo Prata',
              qualifying_score: 10_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 1050},
             {name: 'Executivo Ouro',
              qualifying_score: 52_500,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 5250},
             {name: 'Executivo Rubi',
              qualifying_score: 175_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 17_500},
             {name: 'Executivo Esmeralda',
              qualifying_score: 350_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 35_000},
             {name: 'Diamante',
              qualifying_score: 1_750_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 175_000},
             {name: 'Diamante Azul',
              qualifying_score: 3_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 350_000},
             {name: 'Diamante Negro',
              qualifying_score: 10_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 1_050_000},
             {name: 'Presidente',
              qualifying_score: 17_500_000,
              bonus: 0,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'careers/inactive.png',
              requalification_score: 1_750_000}
            ]
  persisted_careers = careers.map { |career| Career.find_or_create_by!(career) }

  adhesion_category = Category.find_or_create_by!(name: 'Adesão',
                                                  active_session: true,
                                                  active: true)
  activation_category = Category.find_or_create_by!(name: 'Ativação',
                                                    active_session: false,
                                                    active: false)
  detached_category = Category.find_or_create_by!(name: 'Recargas',
                                                  active_session: true,
                                                  active: true)

  sim_card_category = Category.find_or_create_by!(name: 'CHIPs',
                                                  active_session: true,
                                                  active: true,
                                                  code: 10)

  cellphone_reload_category = Category.find_or_create_by!(name: 'CHIPs',
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

  _99_product = Product.find_or_create_by!(name: '99,00',
                                           quantity: 1,
                                           price_cents: 9900,
                                           binary_score: 50,
                                           binary_bonus: 0,
                                           active: true,
                                           virtual: true,
                                           category: activation_category,
                                           paid_by: :paid_by_user,
                                           kind: :activation,
                                           maturity_days: [5, 10],
                                           grace_period: 5)

  _149_product = Product.find_or_create_by!(name: '149,00',
                                            quantity: 1,
                                            price_cents: 14900,
                                            binary_score: 75,
                                            binary_bonus: 0,
                                            active: true,
                                            virtual: true,
                                            category: activation_category,
                                            paid_by: :paid_by_user,
                                            kind: :activation,
                                            maturity_days: [5, 10],
                                            grace_period: 5)

 elite = Product.find_or_create_by!(name: 'Elite',
                                    quantity: 1,
                                    price_cents: 34999,
                                    binary_score: 175,
                                    binary_bonus: 0,
                                    active: true,
                                    virtual: true,
                                    category: adhesion_category,
                                    paid_by: :paid_by_user,
                                    kind: :adhesion)

 premium = Product.find_or_create_by!(name: 'Premium',
                                      quantity: 1,
                                      price_cents: 69999,
                                      binary_score: 350,
                                      binary_bonus: 0,
                                      active: true,
                                      virtual: true,
                                      category: adhesion_category,
                                      paid_by: :paid_by_user,
                                      kind: :adhesion)

date_voice_89 = Product.find_or_create_by!(name: 'Dados e Voz 89',
                                           quantity: 1,
                                           price_cents: 8990,
                                           binary_score: 45,
                                           binary_bonus: 0,
                                           active: true,
                                           virtual: true,
                                           category: detached_category,
                                           paid_by: :paid_by_user,
                                           kind: :detached)

date_voice_49 = Product.find_or_create_by!(name: 'Recarga 34,99' ,
                                           quantity: 1,
                                           price_cents: 3499,
                                           binary_score: 350,
                                           binary_bonus: 0,
                                           active: true,
                                           virtual: true,
                                           category: detached_category,
                                           paid_by: :paid_by_user,
                                           kind: :detached)

reload_34_99 = Product.find_or_create_by!(name: 'Recarga 34,90',
                                     quantity: 1,
                                     price_cents: 3499,
                                     binary_score: 0,
                                     binary_bonus: 0,
                                     active: false,
                                     virtual: false,
                                     category: cellphone_reload_category,
                                     paid_by: :paid_by_user,
                                     kind: :detached)

reload_44_99 = Product.find_or_create_by!(name: 'Recarga 44,99',
                                          quantity: 1,
                                          price_cents: 4499,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached)

reload_69_90 = Product.find_or_create_by!(name: 'Recarga 69,90',
                                          quantity: 1,
                                          price_cents: 6990,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached)

reload_99_99 = Product.find_or_create_by!(name: 'Recarga 99,99',
                                          quantity: 1,
                                          price_cents: 9999,
                                          binary_score: 0,
                                          binary_bonus: 0,
                                          active: false,
                                          virtual: false,
                                          category: cellphone_reload_category,
                                          paid_by: :paid_by_user,
                                          kind: :detached)

reload_119_90 = Product.find_or_create_by!(name: 'Recarga 119,90',
                                           quantity: 1,
                                           price_cents: 11999,
                                           binary_score: 0,
                                           binary_bonus: 0,
                                           active: false,
                                           virtual: false,
                                           category: cellphone_reload_category,
                                           paid_by: :paid_by_user,
                                           kind: :detached)

reload_149_90 = Product.find_or_create_by!(name: 'Recarga 149,90',
                                           quantity: 1,
                                           price_cents: 14990,
                                           binary_score: 0,
                                           binary_bonus: 0,
                                           active: false,
                                           virtual: false,
                                           category: cellphone_reload_category,
                                           paid_by: :paid_by_user,
                                           kind: :detached)

# TRAILS
trails  = [{ name: 'Elite', product: elite, product_bonus: elite_product_bonus },
           { name: 'Premium', product: premium, product_bonus: premium_product_bonus }]
persisted_trails = trails.map { |trail| Trail.find_or_create_by!(trail) }

  persisted_careers.each do |career|
    persisted_trails.each do |trail|
      product = career.qualifying_score <= 10_500 ? _99_product : _149_product
      CareerTrail.find_or_create_by!(career: career, trail: trail, product: product)
    end
  end

  # SCORE TYPES
  score_types = [{ name: 'Pontuação de Adesões', code: '100' },
                 { name: 'Pontuação de Ativação', code: '200' },
                 { name: 'Pontuação de Compras', code: '300' },
                 { name: 'Estorno de Pontuação por Inatividade', code: '800' },
                 { name: 'Pontuação Binária', tree_type: :binary, code: '400' },
                 { name: 'Estorno de Pontuação Binária por Desqualificação', tree_type: :binary, code: '500' },
                 { name: 'Estorno de Pontuação Binária por Inatividade', tree_type: :binary, code: '600' },
                 { name: 'Débito de Bonus Binário', tree_type: :binary, code: '700' }]
  score_types.each { |score_type| ScoreType.find_or_create_by!(score_type) }


  # FINANCIAL REASONS
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
                   { title: 'Estorno de Bonus Binário por Inatividade', code: '600' },
                   { title: 'Estorno de Bonus Binário por Excesso Mensal', code: '700' },
                   { title: 'Estorno de Bonus Binário por Excesso Semanal', code: '800' },
                   { title: 'Estorno de Bonus por Limite de Careeira', code: '900' },
                   { title: 'Bonus Indicacao', code: '1000'},
                   { title: 'Bonus Rendimento', code: '1100'},
                   { title: 'Pagamento de Pedido', code: '1200'},
                   { title: 'Estorno de Bonus Binário por Desqualificação', code: '1300' }]
  bonus_reasons.each do |r|
    FinancialReason.find_or_create_by!(r.merge({financial_reason_type: bonus_type}))
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
