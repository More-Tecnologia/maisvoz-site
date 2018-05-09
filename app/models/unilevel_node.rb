# == Schema Information
#
# Table name: unilevel_nodes
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  username    :string
#  career_kind :string
#  leader      :boolean          default(FALSE), not null
#  ancestry    :string(300)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_unilevel_nodes_on_ancestry  (ancestry)
#  index_unilevel_nodes_on_user_id   (user_id) UNIQUE
#

class UnilevelNode < ApplicationRecord

  belongs_to :user

  has_ancestry

  enum career_kind: {
    consumer: 'consumer',
    affiliate: 'affiliate',
    executive: 'executive',
    bronze: 'bronze',
    silver: 'silver',
    gold: 'gold',
    ruby: 'ruby',
    emerald: 'emerald',
    diamond: 'diamond',
    white_diamond: 'white_diamond',
    blue_diamond: 'blue_diamond',
    black_diamond: 'black_diamond',
    chairman: 'chairman',
    chairman_two_star: 'chairman_two_star',
    chairman_three_star: 'chairman_three_star'
  }

end
