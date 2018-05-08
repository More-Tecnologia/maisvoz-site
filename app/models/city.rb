# == Schema Information
#
# Table name: cities
#
#  id         :bigint(8)        not null, primary key
#  state      :string
#  name       :string
#  ibge       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ApplicationRecord
end
