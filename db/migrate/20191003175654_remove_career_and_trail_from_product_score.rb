class RemoveCareerAndTrailFromProductScore < ActiveRecord::Migration[5.2]
  def change
    remove_reference :product_scores, :career, foreign_key: true
    remove_reference :product_scores, :trail, foreign_key: true
  end
end
