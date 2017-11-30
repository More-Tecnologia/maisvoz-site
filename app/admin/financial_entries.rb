ActiveAdmin.register FinancialEntry do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  index do
    id_column
    column :description
    column :user do |obj|
      link_to obj.user.username,admin_user_path(obj.user)
    end
    column :amount do |obj|
      number_to_currency obj.amount
    end
    column :balance do |obj|
      number_to_currency obj.balance
    end
    column :kind
    column :order
    column :created_at
    actions
  end

end
