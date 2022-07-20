# frozen_string_literal: true

module SharedHelper
  FIRST_BUY_BONUS_AMOUNT_BY_PRODUCTS = {
    1 => 6,
    2 => 15,
    3 => 40,
    4 => 120
  }.freeze
  FREE_BONUS_USER_CREATION_SPAN = 14.days
  FREE_PRODUCT_BONUS_AMOUNT = 20

  def css_class_by_path(path, class_name = 'active')
    class_name if request.path == path
  end

  def format_brl_currency(value)
    number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub(ENV['CURRENT_CURRENCY'] + ' ',
                                                                                '<b>R$</b>')
  end

  def format_usd_currency(value)
    number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub(ENV['CURRENT_CURRENCY'] + ' ',
                                                                                '<b>$</b>')
  end

  def format_currency(value, currency = ENV['CURRENT_CURRENCY'])
    case currency
    when 'USD'
      full_number = format_usd_currency(value)
    when 'BRL'
      full_number = format_brl_currency(value)
    end

    whole_number = full_number[0...-3]
    cents_number = full_number.last(2)

    "#{whole_number}<i>#{cents_number}</i>".html_safe
  end

  def format_currency_with_separator(value, symbol = '<b>$</b>')
    number_to_currency(value, unit: ENV['CURRENT_CURRENCY'], precision: 2).gsub('USD ', symbol).html_safe
  end
end
