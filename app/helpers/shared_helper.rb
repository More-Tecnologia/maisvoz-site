# frozen_string_literal: true

module SharedHelper

  def set_active_css_class(path)
    return 'active' if request.path == path
    ''
  end
end
