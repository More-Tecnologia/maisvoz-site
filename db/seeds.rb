# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  #CAREERS
  careers = [{name: 'Carrera 1',
              qualifying_score: 1000,
              bonus: 100,
              binary_limit: 0,
              kind: :adhesion,
              image_path: 'bronze.png',
              requalification_score: 500 },
             {name: 'Carrera 2',
              qualifying_score: 5000,
              bonus: 200,
              binary_limit: 10,
              kind: :adhesion,
              image_path: 'silver.png',
              requalification_score: 1000}
            ]
  persisted_careers = careers.map { |career| Career.find_or_create_by!(career) }

  # TRAILS
  trails  = [{name: 'Trilha 1'},
             {name: 'Trilha 2'}]
  persisted_trails = trails.map { |trail| Trail.find_or_create_by!(trail) }

  persisted_careers.each do |career|
    persisted_trails.each do |trail|
      CareerTrail.find_or_create_by!(career: career, trail: trail)
    end
  end

  # SCORE TYPES
  score_types = [{ name: 'Pontuação de Adesões' },
                 { name: 'Pontuação de Ativação' },
                 { name: 'Pontuação de Compras' }]
  score_types.each { |score_type| ScoreType.find_or_create_by!(score_type) }


  # FINANCIAL REASONS
  administrative_type = FinancialReasonType.create(name: 'Administrativo Financeiro', code: '100')
  administrative_reasons = [{ title: 'Taxa do Sistema', code: '200' },
                            { title: 'Saque', code: '300' },
                            { title: 'Taxa de Saque', code: '400' }]
  administrative_reasons.each do |r|
    FinancialReason.find_or_create_by!(r.merge({financial_reason_type: administrative_type}))
  end
  bonus_type = FinancialReasonType.find_or_create_by!(name: 'Bonus', code: '200')
  bonus_reasons = [{title: 'Estorno de Bonus', code: '100'}]
  bonus_reasons.each do |r|
    FinancialReason.find_or_create_by!(r.merge({financial_reason_type: bonus_type}))
  end


  # USERS
  more_user = User.create!(username: ENV['MORENWM_USERNAME'],
                           role: 'admin',
                           password: '111111',
                           email: 'morenwm@morenwm.com')
  User.create!(username: ENV['MORENWM_CUSTOMER_USERNAME'],
               role: 'admin',
               password: '111111',
               email: 'customer-morenwm@morenwm.com',
               sponsor: more_user)

end
