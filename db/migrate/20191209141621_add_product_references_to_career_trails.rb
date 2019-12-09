class AddProductReferencesToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_reference :career_trails, :product, foreign_key: true
  end
end
