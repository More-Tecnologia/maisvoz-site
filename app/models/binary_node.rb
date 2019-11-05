class BinaryNode < ApplicationRecord

  include Hashid::Rails

  has_ancestry

  belongs_to :user
  belongs_to :left_child, class_name: 'BinaryNode',
                          optional: true
  belongs_to :right_child, class_name: 'BinaryNode',
                           optional: true
end
