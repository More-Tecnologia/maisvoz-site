class RemoveProductBonusField < ActiveRecord::Migration[5.2]
  def up
    remove_column :products, :bonus_1
    remove_column :products, :bonus_2
    remove_column :products, :bonus_3
    remove_column :products, :bonus_4
    remove_column :products, :bonus_5
    remove_column :products, :bonus_6
    remove_column :products, :bonus_7
    remove_column :products, :bonus_8
    remove_column :products, :bonus_9
    remove_column :products, :upgrade_from_career_id
    remove_column :products, :upgrade_to_career_id
    remove_column :products, :club_motors
    remove_column :products, :tracker

    remove_reference :products, :career
  end

  def down
    add_column :products, :bonus_1, :integer
    add_column :products, :bonus_2, :integer
    add_column :products, :bonus_3, :integer
    add_column :products, :bonus_4, :integer
    add_column :products, :bonus_5, :integer
    add_column :products, :bonus_6, :integer
    add_column :products, :bonus_7, :integer
    add_column :products, :bonus_8, :integer
    add_column :products, :bonus_9, :integer
    add_column :products, :upgrade_from_career_id, :integer
    add_column :products, :upgrade_to_career_id, :integer
    add_column :products, :club_motors, :boolean, default: false, null: false
    add_column :products, :tracker, :boolean, default: false, null: false

    add_reference :products, :careers, foreign_key: true
  end
end
