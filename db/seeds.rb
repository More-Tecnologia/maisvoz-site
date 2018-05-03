# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#################
# Carreiras
ActiveRecord::Base.transaction do

  careers = [
    { name: 'Empreendedor', kind: :adhesion, image_path: 'packages/empreendedor.png' },
    { name: 'Empreendedor Executivo', kind: :qualification, image_path: 'packages/empreendedorStart.png' },
    { name: 'Executivo Bronze', kind: :qualification, image_path: 'packages/executivoBronze.png' },
    { name: 'Executivo Prata', kind: :qualification, image_path: 'packages/executivoPrata.png' },
    { name: 'Executivo Ouro', kind: :qualification, image_path: 'packages/executivoOuro.png' },
    { name: 'Executivo Rubi', kind: :qualification, image_path: 'packages/executivoRuby.png' },
    { name: 'Executivo Esmeralda', kind: :qualification, image_path: 'packages/executivoEsmeralda.png' },
    { name: 'Diamond', kind: :qualification, image_path: 'packages/diamond.png' },
    { name: 'White Diamond', kind: :qualification, image_path: 'packages/whiteDiamond.png' },
    { name: 'Blue Diamond', kind: :qualification, image_path: 'packages/blueDiamond.png' },
    { name: 'Black Diamond', kind: :qualification, image_path: 'packages/blackDiamond.png' },
    { name: 'Chairman Club', kind: :qualification, image_path: 'packages/chairmanClub.png' },
    { name: 'Chairman Club Two Star', kind: :qualification, image_path: 'packages/chairmanTwoStar.png' },
    { name: 'Chairman Club Three Star', kind: :qualification, image_path: 'packages/chairmanThreeStar.png' }
  ]

  # careers.each do |career|
  #   Career.find_or_create_by!(career)
  # end

  AdminUser.create!(email: 'guilhermekfe@outlook.com', password: '111111', password_confirmation: '111111') if Rails.env.development?

end
