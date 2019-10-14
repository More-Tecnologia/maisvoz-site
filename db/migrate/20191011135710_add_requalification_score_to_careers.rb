class AddRequalificationScoreToCareers < ActiveRecord::Migration[5.2]
  def change
    add_column :careers, :requalification_score, :integer, unique: true
  end
end
