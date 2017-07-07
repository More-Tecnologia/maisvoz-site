class AddUpgradeToCareerToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :upgrade_to_career, index: true
  end
end
