module Backoffice
  class DownloadsController < EntrepreneurController

    def index
      render :index, locals: { links: download_links }
    end

    private

    def download_links
      [
        { name: 'Cartão de Visita para Empreendedor', url: 'https://www.dropbox.com/s/hydtieuwnkm3g9b/Cart%C3%A3o%20de%20Visita%20para%20Empreendedores.pdf'},
        { name: 'Adesivos para Carros - Branco', url: 'https://www.dropbox.com/s/anm8402ogrz4uen/Adesivo%20Branco%20Carro.pdf'},
        { name: 'Adesivos para Carros - Preto', url: 'https://www.dropbox.com/s/rzuf2uivhbjsk4r/Adesivo%20Preto%20Carro.pdf'},
        { name: 'Adesivos para Carros - Espelhado', url: 'https://www.dropbox.com/s/ycrg7zzz2b241oq/Adesivo%20Espelhado%20Carro.pdf'},
        { name: 'Modelo para Apresentação do Negócio - 1', url: 'https://www.dropbox.com/s/wtjex154wwszcv8/Modelo%20para%20Apresenta%C3%A7%C3%A3o%20do%20Neg%C3%B3cio_edit%C3%A1vel_01.pdf'},
        { name: 'Modelo para Apresentação do Negócio - 2', url: 'https://www.dropbox.com/s/dzbtslvre3xkzaa/Modelo%20para%20Apresenta%C3%A7%C3%A3o%20do%20Neg%C3%B3cio_edit%C3%A1vel_02.pdf'},
        { name: 'Modelo para Apresentação do Negócio - 3', url: 'https://www.dropbox.com/s/wjjsgml1c61946l/Modelo%20para%20Apresenta%C3%A7%C3%A3o%20do%20Neg%C3%B3cio_edit%C3%A1vel_03.pdf'},
        { name: 'Modelo para o Comece Certo - 1', url: 'https://www.dropbox.com/s/o4dtz7leqqx586g/Modelo%20para%20Comece%20Certo_01.pdf'},
        { name: 'Modelo para o Comece Certo - 2', url: 'https://www.dropbox.com/s/hc0kttojvfguzmt/Modelo%20para%20Comece%20Certo_02.pdf'},
        { name: 'Modelo para o Comece Certo - 3', url: 'https://www.dropbox.com/s/altlgrl581xz9z7/Modelo%20para%20Comece%20Certo_03.pdf'},
      ]
    end

  end
end
