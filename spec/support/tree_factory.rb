class TreeFactory
  include FactoryBot::Syntax::Methods

  HEIGHT = 6

  def create_unilevel(height = HEIGHT)
    parents = [create(:user, username: ENV['MORENWM_CUSTOMER_USERNAME'], active: true)]
    height.times do
      parents = create_children_by_height(parents)
    end
  end

  def create_binary(height = HEIGHT)
    parents = [create(:binary_node)]
    height.times do
      parents = create_binary_children_by_height(parents)
    end
  end

  private

  def create_children_by_height(parents)
    parents.map { |parent| create_children(parent) }.flatten
  end

  def create_children(parent, count = 2)
    active = Faker::Boolean.boolean
    (1..count).to_a.map { create(:user, sponsor: parent, active: active) }
  end

  def create_binary_children_by_height(parents)
    parents.map { |parent| create_binary_children(parent) }.flatten
  end

  def create_binary_children(parent)
    parent.left_child = create_binary_child(parent)
    parent.right_child = create_binary_child(parent)
    parent.save
    [parent.left_child, parent.right_child]
  end

  def create_binary_child(parent)
    create(:binary_node, user: create(:user),
                         parent: parent)
  end
end
