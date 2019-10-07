# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do

  score_types = [{name: 'Pontuação de Adesões'}, {name: 'Pontuação de Ativação'}, {name: 'Pontuação de Compras'}]
  score_types.each { |score_type| ScoreType.create!(score_type) }

  financial_reasons = [{title: 'Estorno de Bonus'}, {name: 'Taxa do Sistema'}]
  financial_reasons.each { |e| FinancialReason.create(e) }

  User.create(username: 'morenwm', role: 'admin', password: '111111', email: 'morenwm@morenwm.com')
  User.create(username: 'maisvoz', role: 'empreendedor', password: '111111', email: 'maisvoz@morenwm.com')

end
