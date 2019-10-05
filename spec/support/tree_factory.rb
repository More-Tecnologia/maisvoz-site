class TreeFactory
  include FactoryBot::Syntax::Methods

  HEIGHT = 6

  def create_unilevel(height = HEIGHT)
    parents = [create(:user, username: ENV['MORENWM_CUSTOMER_USERNAME'])]
    create_morenwm_user(parents.first)
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
    (1..count).to_a.map { create(:user, sponsor: parent) }
  end

  def create_binary_children_by_height(parents)
    parents.map { |parent| create_binary_children(parent) }.flatten
  end

  def create_binary_children(parent, count = 2)
    (1..count).to_a.map do
      create(:binary_node, user: create(:user),
                           sponsored_by: parent.user,
                           parent: parent)
    end
  end

  def create_morenwm_user(sponsor)
    create(:user, sponsor: sponsor)
  end
end
