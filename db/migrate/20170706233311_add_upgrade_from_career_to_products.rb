class AddUpgradeFromCareerToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :upgrade_from_career, index: true
  end
end
