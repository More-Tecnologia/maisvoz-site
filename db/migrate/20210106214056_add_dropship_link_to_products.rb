class AddDropshipLinkToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :dropship_link, :text
  end
end
