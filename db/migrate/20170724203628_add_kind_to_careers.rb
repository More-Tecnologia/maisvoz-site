class AddKindToCareers < ActiveRecord::Migration[5.1]
  def change
    add_column :careers, :kind, :integer, default: 0, null: false
  end
end
