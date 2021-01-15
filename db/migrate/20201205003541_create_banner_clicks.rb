class CreateBannerClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :banner_clicks do |t|
      t.references :user, foreign_key: true
      t.references :banner, foreign_key: true

      t.timestamps
    end
  end
end
