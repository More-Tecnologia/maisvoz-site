class CreateCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :careers do |t|
      t.string :name
      t.string :avatar
      t.integer :qualifying_score, default: 0
      t.integer :bonus, default: 0
      t.integer :binary_limit, default: 0
      t.integer :order, default: 0

      t.timestamps
    end
  end
end
