ActiveAdmin.register PvHistory do
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
    column :order
    column :direction
    column :amount
    column :balance
    column :user do |pv_history|
      link_to pv_history.user.username, admin_user_path(pv_history.user)
    end
    column :created_at
    actions
  end

end
