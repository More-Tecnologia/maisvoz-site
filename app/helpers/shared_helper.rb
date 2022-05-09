# frozen_string_literal: true

module SharedHelper
  def css_class_by_path(path, class_name = 'active')
    class_name if request.path == path
  end

  def format_currency(value, symbol = '<b>$</b>')
    full_number = number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub('USD ', symbol)
    whole_number = full_number[0...-3]
    cents_number = full_number.last(2)

    "#{whole_number}<i>#{cents_number}</i>".html_safe
  end

  def format_currency_with_separator(value, symbol = '<b>$</b>')
    number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub('USD ', symbol).html_safe
  end
end
