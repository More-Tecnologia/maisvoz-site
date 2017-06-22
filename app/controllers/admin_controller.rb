class AdminController < BackofficeController

  protect_from_forgery with: :exception

  layout 'admin'

end
