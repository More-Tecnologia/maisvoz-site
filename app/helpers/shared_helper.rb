# frozen_string_literal: true

module SharedHelper
  def css_class_by_path(path, class_name='active')
    class_name if request.path == path
  end
end
