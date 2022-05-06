# frozen_string_literal: true

module SharedHelper
  def css_class_by_path(path, class_name = 'active')
    class_name if request.path == path
  end

  def format_currency(value, symbol = '<b>$</b>')
    split_value = number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub('USD ', symbol).split('.')
    " #{split_value[0]}<i>#{split_value[1]}</i>".html_safe
  end
end
