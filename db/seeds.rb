# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

master = User.new(username: 'guilhermekfe', email: 'guilhermekfe@outlook.com', password: 111111, role: :admin)
master.skip_confirmation!
master.save!

teste1 = User.new(username: 'teste1', email: 'teste1@morenwm.com', password: 111111, sponsor: master)
teste1.skip_confirmation!
teste1.save!

master_node = BinaryNode.create!(user: master)
teste1_node = BinaryNode.create!(user: teste1, sponsored_by: master, parent: master_node)

master_node.update!(right_child: teste1_node)
