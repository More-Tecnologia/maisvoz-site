ActiveAdmin.register User do

  scope :all
  scope :active do |users|
    users.where(active: true)
  end
  scope :inactive do |users|
    users.where(active: false)
  end
  scope :binary_qualified do |users|
    users.where(binary_qualified: true)
  end

  index do
    id_column
    column :username
    column :name
    column :email
    column :sponsor do |obj|
      if obj.sponsor.present?
        link_to obj.sponsor.username, admin_user_path(obj.sponsor)
      end
    end
    column :role
    column :bought_adhesion
    column :bought_product
    column :binary_position
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column do |obj|
      link_to "Login", login_as_admin_user_path(obj), :target => '_blank'
    end
    actions
  end

  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    bypass_sign_in user
    redirect_to backoffice_dashboard_index_path
  end

  controller do
    def scoped_collection
      User.includes(:sponsor)
    end
  end

end
