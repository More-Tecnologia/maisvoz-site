class ApplicationService

  def self.call(*args, &block)
    new(*args, &block).__send__(:call)
  end

  def h
    ActionController::Base.helpers
  end

end
