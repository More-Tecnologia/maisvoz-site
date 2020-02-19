# frozen_string_literal: true

class CreateMediaFiles < ActiveRecord::Migration[5.2]

  def change
    create_table :media_files do |t|
      t.string :title, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end

end
