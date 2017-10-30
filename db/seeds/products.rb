adhesion_cat = Category.find_or_create_by(name: 'Adesão')
product_cat = Category.find_or_create_by(name: 'Produtos')

products = [
  { name: 'Business Start', price: 150, binary_score: 0, active: true, virtual: true, kind: :adhesion, category: adhesion_cat },
  { name: 'Produto 1', price: 2000, binary_score: 666, active: true, virtual: true, kind: :product, category: product_cat },
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
