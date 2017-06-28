# == Schema Information
#
# Table name: options
#
#  id           :integer          not null, primary key
#  option_name  :string
#  option_value :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Option < ApplicationRecord

  def self.get(option_name)
    raise "Option not available: #{option_name}" unless exists?(option_name: option_name)
    find_by(option_name: option_name).option_value
  end

  def self.set(option_name, option_value)
    find_or_create_by(option_name: option_name, option_value: option_value)
  end

end
