class ApplicationService

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def h
    ActionController::Base.helpers
  end

end
