# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  careers = [{name: 'Carrera 1',
              qualifying_score: 1000,
              bonus: 100,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'bronze.png'},
             {name: 'Carrera 2',
              qualifying_score: 5000,
              bonus: 200,
              binary_limit: 10,
              kind: :adhesion,
              image_path: 'silver.png'}
            ]
  persisted_careers = careers.map { |career| Career.create(career) }

  trails  = [{name: 'Trilha 1'}, {name: 'Trilha 2'}]
  persisted_trails = trails.map { |trail| Trail.create(trail) }

  persisted_careers.each do |career|
    persisted_trails.each do |trail|
      CareerTrail.create(career: career, trail: trail)
    end
  end

  score_types = [{name: 'Pontuação de Adesões'}, {name: 'Pontuação de Ativação'}, {name: 'Pontuação de Compras'}]
  score_types.each { |score_type| ScoreType.create!(score_type) }

  administrative_type = FinancialReasonType.create(name: 'Administrativo Financeiro', code: '100')
  administrative_reasons = [{title: 'Taxa do Sistema'}]
  administrative_reasons.each do |r|
    FinancialReason.create(r.merge({financial_reason_type: administrative_type}))
  end

  bonus_type = FinancialReasonType.create(name: 'Bonus', code: '200')
  bonus_reasons = [{title: 'Estorno de Bonus'}]
  bonus_reasons.each do |r|
    FinancialReason.create(r.merge({financial_reason_type: bonus_type}))
  end

  more_customer = User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
                              role: 'admin',
                              password: '111111',
                              email: 'customer-morenwm@morenwm.com')
  User.create!(username: ENV['MORENWM_USERNAME'],
              role: 'admin',
              password: '111111',
              email: 'morenwm@morenwm.com',
              sponsor: more_customer)
end
