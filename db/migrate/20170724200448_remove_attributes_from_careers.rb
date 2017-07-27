class RemoveAttributesFromCareers < ActiveRecord::Migration[5.1]
  def change
    remove_column :careers, :avatar
    remove_column :careers, :order
  end
end
