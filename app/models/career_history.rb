# == Schema Information
#
# Table name: career_histories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  old_career :string
#  new_career :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_career_histories_on_user_id  (user_id)
#

class CareerHistory < ApplicationRecord

  belongs_to :user, class_name: 'User'

end
