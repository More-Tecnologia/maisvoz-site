ActiveAdmin.register Debit do

  index do
    id_column
    column :operated_by
    column :user
    column :message
    column :amount do |obj|
      number_to_currency obj.amount
    end
    column :created_at
    actions
  end

end
