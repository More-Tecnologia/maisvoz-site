class AddTrailRefToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :trail, foreign_key: true
  end
end
