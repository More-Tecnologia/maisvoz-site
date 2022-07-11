module Backoffice
  module Raffles
    module WinnersHelper
      def render_lotto_list_item(raffle)
        raffle.lotto_numbers.each_with_index.with_object('') do |(number, index), object|
          object << if raffle.lotto_numbers_combination.size > index
                      "<li class='has-arrow'>#{number[0]}<b>#{number[1]}</b></li>"
                    else
                      "<li>#{number}</li>"
                    end
        end.html_safe
      end

      def format_winning_ticket(raffle)
        raffle_ticket_number_format(raffle.winning_ticket)
              .chars
              .map { |num| "<b>#{num}</b>" }
              .join('')
              .html_safe
      end
    end
  end
end
