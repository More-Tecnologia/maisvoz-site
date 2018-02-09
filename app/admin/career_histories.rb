ActiveAdmin.register CareerHistory do
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
    column :user do |history|
      link_to history.user.username, admin_user_path(history.user)
    end
    column :old_career
    column :new_career
    column :created_at
    actions
  end

end
