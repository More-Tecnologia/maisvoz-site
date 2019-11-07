class RemoveSponsoredByFromBinaryNodes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :binary_nodes, :sponsored_by
  end
end
