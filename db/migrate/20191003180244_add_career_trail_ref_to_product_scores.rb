class AddCareerTrailRefToProductScores < ActiveRecord::Migration[5.2]
  def change
    add_reference :product_scores, :career_trail, foreign_key: true
  end
end
