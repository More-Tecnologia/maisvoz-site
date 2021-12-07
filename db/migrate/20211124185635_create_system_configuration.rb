class CreateSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    create_table :system_configurations do |t|
      t.boolean :active, default: true
      t.string :company_name, null: false
      t.float :taxable_fee, default: 0
      t.float :withdrawal_fee, default: 0
    end
  end
end
