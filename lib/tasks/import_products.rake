namespace :import_products do
  desc "Importa produtos"
  task run: :environment do
    puts 'Importing...'

    adC   = Category.find_or_create_by(name: 'Adesão', active: true)
    flexC = Category.find_or_create_by(name: 'H-max Flex', active: true)
    dieC  = Category.find_or_create_by(name: 'H-max Diesel', active: true)
    acC   = Category.find_or_create_by(name: 'Acessórios', active: true)


    desc = 'Formato cilindrico, fabricado com polímeros, materiais de engenharia e ligas de alumínio fundido; o que garante além de uma ótima resistência mecânica uma alta resistência à corrosão, proporcionando vida longa ao nosso produto.'

    products = [
      { name: 'Adesão', price_cents: 15000, binary_score: 0, quantity: '1 unid', description: 'KIT ASSOCIATION - Curso Comece Certo. Treinamento Avançado de Líderes', category: adC, kind: :adhesion },
      { name: 'Camisa Future Green ', price_cents: 7990, binary_score: 0, quantity: '1 unid', description: 'Camiseta Malha Fria Fio 30 com Viéis Verde Future Green', category: acC, kind: :product },
      { name: 'Camisa Comece Certo', price_cents: 7990, binary_score: 0, quantity: '1 unid', description: 'Camiseta Malha Fria Fio 30 com Viéis Azul Comece Certo', category: acC, kind: :product },
      { name: 'Kit Fluido', price_cents: 12002, binary_score: 0, quantity: '24 unid', description: 'FLUIDO BIO-ELETROLITO (500 ML), SACHÊ- COMPONENTE QUÍMICO BIO-DEGRADÁVEL (2,50 G)', category: acC, kind: :product },
      { name: 'Kit Instalador Credenciado', price_cents: 50000, binary_score: 0, quantity: '14 itens', description: 'ANEL ORING 105x2,77MM EPDM (anel de vedação)\nCONECTOR DE DERIVAÇÃO  (jamper elétrico)\nCONEXÃO PNEUM. 90° 1/8NPT P/ 6MM\nCONEXÃO PNEUM. RETA 1/8NPT P/ 6MM\nFLACONETE\nFLUIDO 500ML\nMANGUEIRA PNEUMATICA\nPARAFUSO  ALLEN C/C  M6X35MM INOX\nARRUELA 6,0X12,5X1,6MM \nPORCA M6 \nPLUG PINO TAMPÃO DE BORRACHA PNEUMA  1/4  6MM\nSISTEMA ELETRONICO DE CONTROLE EMBALADO\nSUPORTE  DE BORRACHA PARA LED\nTAMPÃO DE BORRACHA (isolamento eletrico)', category: acC, kind: :product },
      { name: 'Kit Cabo Elétrico Vermelho', price_cents: 3330, binary_score: 0, quantity: '50 mt', description: 'CABO ELETRICO 1,5 COR VERMELHO', category: acC, kind: :product },
      { name: 'Kit Conduite Corrugado', price_cents: 5550, binary_score: 0, quantity: '50 mt', description: 'CONDUITE CONRRUGADO BI PARTICO', category: acC, kind: :product },
      { name: 'Kit Conector de Derivação', price_cents: 330, binary_score: 0, quantity: '10 unid', description: 'CONECTOR DE DERIVAÇÃO  (jamper elétrico)', category: acC, kind: :product },
      { name: 'Kit Conexão Peneum. 90º', price_cents: 6664, binary_score: 0, quantity: '10 unid', description: 'CONEXÃO PNEUM. 90° 1/8NPT P/ 6MM', category: acC, kind: :product },
      { name: 'Kit Conexão Peneum. Reta ', price_cents: 3568, binary_score: 0, quantity: '10 unid', description: 'CONEXÃO PNEUM. RETA 1/8NPT P/ 6MM', category: acC, kind: :product },
      { name: 'Kit Mangueira Pneumatica ', price_cents: 9990, binary_score: 0, quantity: '50 mt', description: 'MANGUEIRA PNEUMATICA', category: acC, kind: :product },
      { name: 'Kit Pino Tampão', price_cents: 9336, binary_score: 0, quantity: '20 unid', description: 'PLUG PINO TAMPÃO DE BORRACHA PNEUMA  1/4  6MM', category: acC, kind: :product },
      { name: 'Kit Eletrônico', price_cents: 40001, binary_score: 0, quantity: '4 unid', description: 'SISTEMA ELETRONICO DE CONTROLE EMBALADO', category: acC, kind: :product },
      { name: 'Kit Suporte para Led', price_cents: 3332, binary_score: 0, quantity: '10 unid', description: 'SUPORTE  DE BORRACHA PARA LED', category: acC, kind: :product },
      { name: 'Kit Tampão de Borracha', price_cents: 6669, binary_score: 0, quantity: '10 unid', description: 'TAMPÃO DE BORRACHA (isolamento eletrico)', category: acC, kind: :product },
      { name: 'Kit Anel de Vedação', price_cents: 6664, binary_score: 0, quantity: '10 unid', description: 'ANEL ORING 105x2,77MM EPDM (anel de vedação)', category: acC, kind: :product },
      { name: 'Kit Parafuso de fixação', price_cents: 1109, binary_score: 0, quantity: '10 unid', description: 'PORCA M6\nPARAFUSO  ALLEN C/C  M6X35MM INOX\nARRUELA 6,0X12,5X1,6MM', category: acC, kind: :product },
      { name: 'H-Max Flex 1.0 a 2.0', price_cents: 230000, binary_score: 700, quantity: '1 peça', description: desc, category: flexC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Flex 2.1 a 3.2', price_cents: 350000, binary_score: 900, quantity: '1 peça', description: desc, category: flexC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Flex 3.3 a 5.2', price_cents: 500000, binary_score: 1250, quantity: '1 peça', description: desc, category: flexC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 1.0 a 2.0', price_cents: 280000, binary_score: 730, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 2.1 a 3.4', price_cents: 380000, binary_score: 950, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 3.5 a 5.2', price_cents: 500000, binary_score: 1250, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 5.5 a 7.1', price_cents: 600000, binary_score: 1500, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 7.2 a 8.5', price_cents: 800000, binary_score: 2100, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
      { name: 'H-Max Diesel 8.6 a 15.0', price_cents: 1000000, binary_score: 2600, quantity: '1 peça', description: desc, category: dieC, kind: :product, height: 15.8, width: 15.8, length: 8.4, weight: 1.5 },
    ]

    products.each do |p|
      Product.find_or_create_by(name: p[:name]) do |product|
        puts "Importando #{product.name}..."
        product.active       = true
        product.price_cents  = p[:price_cents]
        product.binary_score = p[:binary_score]
        product.quantity     = p[:quantity]
        product.description  = p[:description]
        product.kind         = p[:kind]
        product.category     = p[:category]
        product.height       = p[:height]
        product.width        = p[:width]
        product.length       = p[:length]
        product.weight       = p[:weight]
      end
    end

    puts 'Imported!'

  end
end
