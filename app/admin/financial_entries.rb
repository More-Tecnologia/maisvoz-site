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


  scope :all
  scope :direct_indication_bonus
  scope :executive_sale_bonus
  scope :binary_bonus
  scope :reverse_binary_bonus
  scope :flex_bonus
  scope :activity_bonus
  scope :social_leader_bonus
  scope :installer_bonus
  scope :reverse_bonus
  scope :bonus_chargeback
  scope :credit_by_admin
  scope :debit_by_admin
  scope :fee
  scope :withdrawal_fee
  scope :product_return
  scope :tax
  scope :transfer
  scope :withdrawal
  scope :third_order_payment

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
