ActiveAdmin.register BinaryNode do
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
    column :user do |obj|
      link_to obj.user.username, admin_user_path(obj.user)
    end
    column :sponsor do |obj|
      if obj.sponsored_by.present?
        link_to obj.sponsored_by.username, admin_user_path(obj.sponsored_by)
      end
    end
    column :parent
    column :left_child
    column :right_child
    column :left_pv
    column :right_pv
    column :career
    column :qualified
    column :active
    column :active_until
    column :created_at
    actions
  end

end
