require 'csv'

namespace :import_users do
  task run: :environment do
    puts 'importing users...'
    filename = File.join Rails.root, 'users_fm.csv'

    matrix = %w[チ ェ ー ン は ネ ッ ト ワ ー ク 上 の ノ ー ド に 分 散 的 に 記 録 さ れ る 。 過 去 の す べ て の 取 引 が 記 録 さ れ て い る た め こ れ を 見 れ ば 取 引 の 整 合 性 を 誰 で も 検 証 す る こ と が で き る]

    ActiveRecord::Base.transaction do

      master = User.new(id: 1, username: 'sistema', email: 'sistema@morenwm.com', password: 111111, role: :admin)
      master.save!
      BinaryNode.create!(user: master)

      adhesion = Product.find_by(name: 'Adesão')

      l = 0

      CSV.foreach(filename, headers: true) do |row|
        l += 1
        row = row.to_hash
        row['sponsor'] = row['sponsor'] && row['sponsor'].downcase
        row['username'] = I18n.transliterate(row['username'].downcase)
        row['email'] = row['email'] && row['email'].downcase
        row['address'] = row['address'] && row['address'].mb_chars.titleize.to_s
        row['address_2'] = row['address_2'] && row['address_2'].mb_chars.titleize.to_s
        row['district'] = row['district'] && row['district'].mb_chars.titleize.to_s
        row['city'] = row['city'] && row['city'].mb_chars.titleize.to_s
        row['state'] = row['state'] && I18n.transliterate(row['state'].mb_chars.titleize).to_s
        row['name'] = row['name'].mb_chars.titleize.to_s
        row['document_rg_expeditor'] = row['document_rg_place']

        row['document_cpf'] = row['cpfcnpj'] if row['cpfcnpj'] && row['cpfcnpj'].length == 11
        row['document_cnpj'] = row['cpfcnpj'] if row['cpfcnpj'] && row['cpfcnpj'].length == 14

        position = row['left'].present? ? 'left' : 'right'

        puts "L_#{l} importing user: #{row['username']} sponsor: #{row['sponsor']}... #{matrix.sample}"

        sponsor = User.find_by!(username: row['sponsor']) if row['sponsor']

        restrictions = %w[id idd left right sponsor sponsor_name aa cpfcnpj document_rg_place]

        user = User.new(row.except(*restrictions).symbolize_keys)
        user.sponsor = sponsor
        user.binary_position = position
        user.password = 111111

        user.save!

        order = Order.new(user: user)
        Shopping::AddToCart.call(order, adhesion.id)
        order.pending_payment!
        Financial::PaymentCompensation.new(order).call
      end
    end
  end
end
