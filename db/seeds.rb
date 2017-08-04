# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

master = User.new(username: 'guilhermekfe', email: 'guilhermekfe@outlook.com', password: 111111, role: :admin)
# master.skip_confirmation!
master.save!

teste1 = User.new(username: 'teste1', email: 'teste1@morenwm.com', password: 111111, sponsor: master)
# teste1.skip_confirmation!
teste1.save!

master_node = BinaryNode.create!(user: master)
teste1_node = BinaryNode.create!(user: teste1, sponsored_by: master, parent: master_node)

master_node.update!(right_child: teste1_node)

# Create mass users
users = [
  { username: 'user1', email: 'user1@email.com', password: 111111, sponsor: teste1 },
  { username: 'user2', email: 'user2@email.com', password: 111111, sponsor: teste1 },
  { username: 'user3', email: 'user3@email.com', password: 111111, sponsor: teste1 },
  { username: 'user4', email: 'user4@email.com', password: 111111, sponsor: teste1 },
  { username: 'user5', email: 'user5@email.com', password: 111111, sponsor: teste1 },
  { username: 'user6', email: 'user6@email.com', password: 111111, sponsor: teste1 },
  { username: 'user7', email: 'user7@email.com', password: 111111, sponsor: teste1 },
  { username: 'user8', email: 'user8@email.com', password: 111111, sponsor: teste1 },
]

users.each { |u| User.create!(u) }

# Create Career
career = Career.create!(name: 'Carreira 1', kind: :adhesion, binary_percentage: 20.0)
teste1_node.update!(career: career)

# Create Category
category = Category.create!(name: 'Categoria', active: true)

# Create Product
product = Product.create!(name: 'Adesão', price: 100, binary_score: 500, category: category, career: career, active: true, kind: :adhesion)
