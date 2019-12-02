class AddCodeToScoreType < ActiveRecord::Migration[5.2]
  def change
    add_column :score_types, :code, :integer
  end
end
