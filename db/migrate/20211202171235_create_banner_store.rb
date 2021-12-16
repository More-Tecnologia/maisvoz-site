class CreateBannerStore < ActiveRecord::Migration[5.2]
  def change
    create_table :banner_stores do |t|
      t.boolean :active, default: true
      t.string :title, null: false
    end
  end
end
