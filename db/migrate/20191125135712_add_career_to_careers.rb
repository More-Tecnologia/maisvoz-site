class AddCareerToCareers < ActiveRecord::Migration[5.2]
  def change
    add_reference :careers, :career, foreign_key: true
  end
end
