class BinaryNodeSearchByUserQuery

  def initialize(params)
    @username = params[:username]
    @id = params[:id]
  end

  def call
    if username.present?
      find_by_username
    else
      find_by_id
    end
  end

  private

  attr_reader :username, :id

  def find_by_username
    User.find_by(username: username).try(:binary_node)
  end

  def find_by_id
    BinaryNode.find(id)
  end

end
