require 'rqrcode'

module Backoffice
  module BlockCheckoutsHelper
    def format_digital_currency(amount)
      ENV['CURRENT_DIGITAL_CURRENCY'] + ' ' + amount.to_s
    end

    def format_whitelabel_currency(amount)
      unless ActiveModel::Type::Boolean.new.cast(ENV['WHITELABEL'])
        amount = amount * ENV['REAL_USD_FACTOR']
      end

      ENV['CURRENT_CURRENCY'] + ' ' + amount.to_s
    end

    def generate_qr_code(text)
      qrcode = RQRCode::QRCode.new(text)
      qrcode.as_png(bit_depth: 1,
                    border_modules: 4,
                    color_mode: ChunkyPNG::COLOR_GRAYSCALE,
                    color: 'black',
                    file: nil,
                    fill: 'white',
                    module_px_size: 6,
                    resize_exactly_to: false,
                    resize_gte_to: false,
                    size: 250)
    end

    def render_qr_code_img(string)
      qr_code = generate_qr_code(string)
      qr_code_base64 = Base64.encode64(qr_code.to_blob)
      src = "data:image/png;base64,#{qr_code_base64}"
      image_tag src
    end
  end
end
