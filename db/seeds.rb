# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#################
# Carreiras

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

careers.each do |career|
  Career.find_or_create_by!(career)
end

master = User.new(username: 'sistema', email: 'sistema@email.com', password: 111111, role: :admin)
# master.skip_confirmation!
master.save!

fm = User.new(username: 'futuremotors', email: 'teste1@morenwm.com', password: 111111, sponsor: master, binary_position: 'left')
# teste1.skip_confirmation!
fm.save!

master_node = BinaryNode.create!(user: master)
teste1_node = BinaryNode.create!(user: fm, sponsored_by: master, parent: master_node, active_until: 1.year.from_now)
#
master_node.update!(left_child: teste1_node)

#####################
# Create mass users

users = [
  { username: 'rubem', email: 'rubem@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'eduardo', email: 'eduardo@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'diogo', email: 'diogo@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'ricardo', email: 'ricardo@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'divino', email: 'divino@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'clube12', email: 'clube12@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'onofre', email: 'onofre@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'elizel', email: 'elizel@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'emerson', email: 'emerson@email.com', password: 111111, sponsor_username: 'diogo', binary_position: 'left' },
  { username: 'itamar', email: 'itamar@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'bernardo', email: 'bernardo@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'cleiton', email: 'cleiton@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'cristiene', email: 'cristiene@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'right' },
  { username: 'jubio', email: 'jubio@email.com', password: 111111, sponsor_username: 'rubem', binary_position: 'left' },
  { username: 'herica', email: 'herica@email.com', password: 111111, sponsor_username: 'futuremotors', binary_position: 'left' },
  { username: 'marcelo', email: 'marcelo@email.com', password: 111111, sponsor_username: 'rubem', binary_position: 'right' },
  { username: 'paulo', email: 'paulo@email.com', password: 111111, sponsor_username: 'diogo', binary_position: 'right' },
  { username: 'roosevelt', email: 'roosevelt@email.com', password: 111111, sponsor_username: 'diogo', binary_position: 'right' },
  { username: 'renilson', email: 'renilson@email.com', password: 111111, sponsor_username: 'eduardo', binary_position: 'left' },
  { username: 'gabriel', email: 'gabriel@email.com', password: 111111, sponsor_username: 'ricardo', binary_position: 'left' },
  { username: 'pedro', email: 'pedro@email.com', password: 111111, sponsor_username: 'eduardo', binary_position: 'right' },
]

users.each do |u|
  user = User.new(u.except(:sponsor_username))
  user.sponsor = User.find_by(username: u[:sponsor_username])
  user.save!
end

# Create Category
adhCategory = Category.create!(name: 'Adesão', active: true)

# Create Product
product = Product.create!(name: 'Adesão', price: 150, binary_score: 0, category: adhCategory, active: true, kind: :adhesion)

AdminUser.create!(email: 'guilhermekfe@outlook.com', password: '111111', password_confirmation: '111111') if Rails.env.development?
