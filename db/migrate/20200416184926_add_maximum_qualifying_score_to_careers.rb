class AddMaximumQualifyingScoreToCareers < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :maximum_qualifying_score, :integer, default: 0
  end
end
