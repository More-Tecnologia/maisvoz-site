module Backoffice
  module BannersHelper
    def advertisements
      [['advertisement1.jpg', 'https://tinyurl.com/y3lft9et'],
       ['advertisement2.jpg', 'https://tinyurl.com/y6hjoqdf'],
       ['advertisement3.jpg', 'https://tinyurl.com/y35m75ex'],
       ['advertisement4.jpg', 'https://tinyurl.com/y4mkb96g'],
       ['advertisement5.jpg', 'https://tinyurl.com/y5gn8dj4'],
       ['advertisement6.jpg', 'https://tinyurl.com/y48p75cr'],
       ['advertisement7.jpg', 'https://tinyurl.com/y3curer7'],
       ['advertisement8.jpg', 'https://tinyurl.com/y3gxsq5a'],
       ['advertisement9.jpg', 'https://tinyurl.com/y3d4tssf'],
       ['advertisement10.jpg', 'https://tinyurl.com/y3f7spfr'],
       ['advertisement11.jpg', 'https://tinyurl.com/y4e9bsk2'],
       ['advertisement12.jpg', 'https://tinyurl.com/y5tbvbwy'],
       ['advertisement13.jpg', 'https://tinyurl.com/yxcozs5y'],
       ['advertisement14.jpg', 'https://tinyurl.com/y4r6smna'],
       ['advertisement15.jpg', 'https://tinyurl.com/y2l9nfzw'],
       ['advertisement16.jpg', 'https://tinyurl.com/y54q4269'],
       ['advertisement17.jpg', 'https://tinyurl.com/yxg3e26f'],
       ['advertisement18.jpg', 'https://tinyurl.com/yywzkw4d'],
       ['advertisement19.jpg', 'https://tinyurl.com/y4gv7epn'],
       ['advertisement20.jpg', 'https://tinyurl.com/y53ph9p4'],
       ['advertisement21.jpg', 'https://tinyurl.com/y6tau6bs'],
       ['advertisement22.jpg', 'https://tinyurl.com/yyutcb5x'],
       ['advertisement23.jpg', 'https://tinyurl.com/yyutcb5x'],
       ['advertisement24.jpg', 'https://tinyurl.com/y3twv9rl'],
       ['advertisement25.jpg', 'https://tinyurl.com/y36otajt'],
       ['advertisement26.jpg', 'https://tinyurl.com/yxuk7yzc']]
    end

    def sample_advertisement(count = 5)
      @sample_adverts ||= advertisements.sample(count)
    end

    def advertisement_image_link(advertisement)
      link_to advertisement.second, target: '_blank' do
        image_tag "adverts/#{advertisement.first}"
      end
    end
  end
end
