deposit_cat = Category.find_or_create_by(name: 'Deposit')

products = [
  { name: 'Deposit', price: 1, binary_score: 0, active: true, virtual: true, kind: :deposit, category: deposit_cat }
]

products.each do |product|
  Product.find_or_create_by!(name: product[:name]) do |model|
    model.price        = product[:price]
    model.binary_score = product[:binary_score]
    model.active       = product[:active]
    model.virtual      = product[:virtual]
    model.kind         = product[:kind]
    model.category     = product[:category]
  end
end
