class AddImagePathToCareers < ActiveRecord::Migration[5.1]
  def change
    add_column :careers, :image_path, :string
  end
end
