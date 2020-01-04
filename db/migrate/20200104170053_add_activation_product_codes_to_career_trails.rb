class AddActivationProductCodesToCareerTrails < ActiveRecord::Migration[5.2]
  def change
    add_column :career_trails, :activation_product_codes, :text
  end
end
