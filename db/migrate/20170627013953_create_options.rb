class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.string :option_name
      t.string :option_value

      t.timestamps
    end
  end
end
