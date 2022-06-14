# frozen_string_literal: true

class AddWhitelabelToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :whitelabel, :boolean, default: true
  end
end
