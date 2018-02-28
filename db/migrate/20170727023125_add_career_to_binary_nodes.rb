class AddCareerToBinaryNodes < ActiveRecord::Migration[5.1]
  def up
    add_reference :binary_nodes, :career, foreign_key: true
  end

  def down
    remove_reference :binary_nodes, :career
  end
end
