module Backoffice
  class DownloadsController < EntrepreneurController

    def index
      render :index, locals: { links: download_links }
    end

    private

    def download_links
      [
        { name: 'Cartão de Visita para Empreendedor', url: 'https://www.dropbox.com/s/hydtieuwnkm3g9b/Cart%C3%A3o%20de%20Visita%20para%20Empreendedores.pdf'},
        { name: 'Folder Multifuncional H-MAX', url: 'https://www.dropbox.com/s/m5o0o9dlq21snns/Folder%20Multifuncional%20H-MAX.pdf'},
        { name: 'Panfleto H-MAX', url: 'https://www.dropbox.com/s/udi9lrarbs31v7q/Panfleto%20H-MAX.pdf'},
        { name: 'Modelos de Convite para Eventos', url: 'https://www.dropbox.com/s/cilnry06058fjgy/Modelo%20de%20Convite.pdf'},
        { name: 'Manual do Negócio', url: 'https://www.dropbox.com/s/9atfdjymv4u76fw/Manual%20do%20Plano%20de%20Negocio_20180205.pdf'},
        { name: 'Plano de Compensação', url: 'https://www.dropbox.com/s/a7kehg1lbyxh3ii/PLANO%20DE%20COMPENSA%C3%87%C3%83O_20180205.pdf'},
        { name: 'Apresentação do Negócio', url: 'https://www.dropbox.com/s/5y9mbk55c9f36b6/APN%20VERS%C3%83O%20COMPLETA.pdf'},
        { name: 'Instalação do H-max', url: 'https://youtu.be/BDu_fUOtodQ'},
        { name: 'H-max inovacão tecnológica', url: 'https://youtu.be/RYAupehqGmE'},
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
