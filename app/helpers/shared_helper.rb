# frozen_string_literal: true

module SharedHelper
  def active_css_class_by_path(path)
    return 'active' if request.path == path
  end
end
