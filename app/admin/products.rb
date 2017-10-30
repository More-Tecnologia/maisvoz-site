ActiveAdmin.register Product do

  index do
    id_column
    column :name
    column :sku
    column :quantity
    column 'Price' do |product|
      number_to_currency product.price
    end
    column :binary_score
    column :advance_score
    column :active
    column :category
    column :career
    column :kind
    column :created_at
    actions
  end

end
