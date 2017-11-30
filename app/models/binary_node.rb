# == Schema Information
#
# Table name: binary_nodes
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  sponsored_by_id :integer
#  parent_id       :integer
#  left_child_id   :integer
#  right_child_id  :integer
#  left_pv         :integer          default(0)
#  right_pv        :integer          default(0)
#  left_count      :integer          default(0)
#  right_count     :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  career_id       :integer
#  active          :boolean          default(TRUE), not null
#  active_until    :date
#  qualified       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_binary_nodes_on_career_id        (career_id)
#  index_binary_nodes_on_left_child_id    (left_child_id)
#  index_binary_nodes_on_parent_id        (parent_id)
#  index_binary_nodes_on_right_child_id   (right_child_id)
#  index_binary_nodes_on_sponsored_by_id  (sponsored_by_id)
#  index_binary_nodes_on_user_id          (user_id) UNIQUE
#

class BinaryNode < ApplicationRecord

  delegate :name, to: :career, allow_nil: true, prefix: true

  has_many :children_nodes, class_name: 'BinaryNode', foreign_key: 'parent_id'
  has_one :upper_right_parent, class_name: 'BinaryNode', foreign_key: 'right_child_id'
  has_one :upper_left_parent, class_name: 'BinaryNode', foreign_key: 'left_child_id'

  belongs_to :user
  belongs_to :career, optional: true
  belongs_to :sponsored_by, class_name: 'User', optional: true
  belongs_to :parent, class_name: 'BinaryNode', optional: true
  belongs_to :left_child, class_name: 'BinaryNode', optional: true
  belongs_to :right_child, class_name: 'BinaryNode', optional: true

end
