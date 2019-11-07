module Backoffice
  class DownloadsController < BackofficeController

    def index
      render :index, locals: { links: download_links, images: images }
    end

    private

    def download_links
      [
        { name: 'Cartão de Visita para Empreendedor', url: '#' },
        { name: 'Adesivos para Carros - Branco', url: '#' },
        { name: 'Adesivos para Carros - Preto', url: '#' },
        { name: 'Adesivos para Carros - Espelhado', url: '#' },
        { name: 'Apresentação', url: '#' }
      ]
    end

    def images
      [
        'https://via.placeholder.com/600/FFF/192C4C/?text=600x600',
        'https://via.placeholder.com/600/FFF/192C4C/?text=600x600',
        'https://via.placeholder.com/600/FFF/192C4C/?text=600x600',
        'https://via.placeholder.com/600/FFF/192C4C/?text=600x600'
      ]
    end

  end
end
