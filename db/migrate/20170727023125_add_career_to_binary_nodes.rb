class AddCareerToBinaryNodes < ActiveRecord::Migration[5.1]
  def change
    add_reference :binary_nodes, :career, foreign_key: true
  end
end
