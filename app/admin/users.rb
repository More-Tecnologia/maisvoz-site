ActiveAdmin.register User do

  index do
    id_column
    column :username
    column :name
    column :email
    column :sponsor
    column :role
    column :bought_adhesion
    column :bought_product
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    actions
  end

end
