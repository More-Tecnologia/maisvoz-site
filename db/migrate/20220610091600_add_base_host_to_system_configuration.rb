# frozen_string_literal: true

class AddBaseHostToSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    add_column :system_configurations, :base_host, :string, default: ''
  end
end
