ActiveAdmin.register Order do

  show do
    attributes_table do
      row :user
      row :subtotal
      row :tax
      row :shipping
      row :total
      row :status
      row :payment_status
      row :paid_at
      row :created_at
    end
    panel 'Order items' do
      table_for order.order_items do
        column :id
        column :name
        column :unit_price
        column :quantity
        column :total
      end
    end
  end

  index do
    id_column
    column :user
    column :total, sortable: :total_cents do |o|
      number_to_currency o.total
    end
    column :status
    column :payment_status
    column :paid_at
    column :created_at
    column :pay do |obj|
      link_to 'Pay Order', pay_order_admin_order_path(obj), method: :post unless obj.completed?
    end
    actions
  end

  member_action :pay_order, method: :post do
    command = Financial::PaymentCompensation.call(resource)

    if command.success?
      flash[:success] = I18n.t('defaults.approved_success')
    else
      flash[:error] = command.errors[:order].join(',')
    end
    redirect_to resource_path
  end

end
