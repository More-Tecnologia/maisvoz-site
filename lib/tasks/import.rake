namespace :import do
  desc "TODO"
  task club_motors: :environment do
    import_fees
    import_brands
    import_models
  end

  private

  def import_fees
    fees = [
      {id: 1, name: 'Compacto', standard_fee_cents: 69_00, master_fee_cents: 95_00, premium_fee_cents: 125_00 },
      {id: 2, name: 'Executivo', standard_fee_cents: 95_00, master_fee_cents: 125_00, premium_fee_cents: 145_00 },
      {id: 3, name: 'Prime', standard_fee_cents: 125_00, master_fee_cents: 145_00, premium_fee_cents: 169_00 },
      {id: 4, name: 'Utilitário', standard_fee_cents: 145_00, master_fee_cents: 169_00, premium_fee_cents: 205_00 },
      {id: 5, name: 'Especial', standard_fee_cents: 250_00, master_fee_cents: 375_00, premium_fee_cents: 550_00 }
    ]

    fees.each do |fee|
      next if ClubMotorsFee.exists? id: fee[:id]

      club_motors_fee = ClubMotorsFee.new(fee)
      club_motors_fee.id = fee[:id]
      club_motors_fee.save!
    end
  end

  def import_brands
    brands =[
      [1,'Acura',1],
      [2,'Agrale',1],
      [3,'Alfa Romeo',1],
      [4,'AM Gen',1],
      [5,'Asia Motors',1],
      [189,'ASTON MARTIN',1],
      [6,'Audi',1],
      [207,'Baby',1],
      [7,'BMW',1],
      [8,'BRM',1],
      [123,'Bugre',1],
      [10,'Cadillac',1],
      [11,'CBT Jipe',1],
      [136,'CHANA',1],
      [182,'CHANGAN',1],
      [161,'CHERY',1],
      [12,'Chrysler',1],
      [13,'Citroën',1],
      [14,'Cross Lander',1],
      [15,'Daewoo',1],
      [16,'Daihatsu',1],
      [17,'Dodge',1],
      [147,'EFFA',1],
      [18,'Engesa',1],
      [19,'Envemo',1],
      [20,'Ferrari',1],
      [21,'Fiat',1],
      [149,'Fibravan',1],
      [22,'Ford',1],
      [190,'FOTON',1],
      [170,'Fyber',1],
      [199,'GEELY',1],
      [23,'GM - Chevrolet',1],
      [153,'GREAT WALL',1],
      [24,'Gurgel',1],
      [152,'HAFEI',1],
      [25,'Honda',1],
      [26,'Hyundai',1],
      [27,'Isuzu',1],
      [208,'IVECO',1],
      [177,'JAC',1],
      [28,'Jaguar',1],
      [29,'Jeep',1],
      [154,'JINBEI',1],
      [30,'JPX',1],
      [31,'Kia Motors',1],
      [32,'Lada',1],
      [171,'LAMBORGHINI',1],
      [33,'Land Rover',1],
      [34,'Lexus',1],
      [168,'LIFAN',1],
      [127,'LOBINI',1],
      [35,'Lotus',1],
      [140,'Mahindra',1],
      [36,'Maserati',1],
      [37,'Matra',1],
      [38,'Mazda',1],
      [39,'Mercedes-Benz',1],
      [40,'Mercury',1],
      [167,'MG',1],
      [156,'MINI',1],
      [41,'Mitsubishi',1],
      [42,'Miura',1],
      [43,'Nissan',1],
      [44,'Peugeot',1],
      [45,'Plymouth',1],
      [46,'Pontiac',1],
      [47,'Porsche',1],
      [185,'RAM',1],
      [186,'RELY',1],
      [48,'Renault',1],
      [195,'Rolls-Royce',1],
      [49,'Rover',1],
      [50,'Saab',1],
      [51,'Saturn',1],
      [52,'Seat',1],
      [183,'SHINERAY',1],
      [157,'smart',1],
      [125,'SSANGYONG',1],
      [54,'Subaru',1],
      [55,'Suzuki',1],
      [165,'TAC',1],
      [56,'Toyota',1],
      [57,'Troller',1],
      [58,'Volvo',1],
      [59,'VW - VolksWagen',1],
      [163,'Wake',1],
      [120,'Walk',1]
    ]

    brands.each do |brand|
      puts "Importing #{brand[1]}..."
      CarBrand.find_or_create_by!(
        brand_code: brand[0],
        name: brand[1],
        type: brand[2]
      )
    end
  end

  def import_models
    CSV.foreach('lib/tasks/data/fipe_carros.csv', headers: true) do |row|

      model = CarModel.find_or_initialize_by(
        model_code: row['codigo_modelo'].to_i,
        brand_code: row['codigo_marca'].to_i,
        fipe_code: row['codigo_fipe'],
        name: row['modelo'],
        type: row['tipo'].to_i
      )

      model.club_motors_fee_id = row['codigo_mensalidade'].to_i if row['codigo_mensalidade'].present?

      puts model.attributes

      model.save!
    end
  end

end
