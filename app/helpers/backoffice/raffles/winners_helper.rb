module Backoffice
  module Raffles
    module WinnersHelper
      def render_lotto_list_item(raffle)
        split_number = raffle.lotto_numbers_combination.split('')
        list_item = ''
        raffle.lotto_numbers.each_with_index do |number, index|
          lotto_number = number.split('')
          list_item = if split_number.length > index
                        list_item + "<li class='has-arrow'>#{lotto_number[0]}<b>#{lotto_number[1]}</b></li>"
                      else
                        list_item + "<li>#{number}</li>"
                      end
        end
        list_item.html_safe
      end

      def format_winning_ticket(raffle)
        split_number = raffle.lotto_numbers_combination.split('')
        formated_number = ''

        split_number.each do |num|
          formated_number += "<b>#{num}</b>"
        end

        formated_number.html_safe
      end
    end
  end
end
