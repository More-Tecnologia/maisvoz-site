module Backoffice
  module BannersHelper
    def banner_image_link(banner)
      image_path =
        banner.image_path.blank? ? 'fallback/default_product.png' : banner.image_path

      link_to backoffice_banner_clicks_path(banner_id: banner.id),
              method: :post,
              remote: true do
        image_tag(image_path, class: 'thumb-lg')
      end
    end
  end
end
