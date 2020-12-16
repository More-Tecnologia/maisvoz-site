namespace :users do
  task check_level: :environment do
    Tasks::CheckLevelUp.call
  end

  task import: :environment do
    ActiveRecord::Base.transaction do
      users_file_path = Rails.root.join('db/seeds/data/users.csv')
      headers = %i[id user_login user_email display_name sponsor_id wallet_amount contadorUdgrade gananciaDoble ganado]
      users = CSV.read(users_file_path, headers: headers).index_by { |u| u[:id] }

      deposit_product = Product.first
      puts users.size

      users.each do |id, user|
        begin
          form_headers = %i[name sponsor_username document_cpf email country username password password_confirmation]

          sponsor_id = user[:sponsor_id].in?(['0', '1']) ? 3 : user[:sponsor_id]
          raise "Sponsor not found #{user}" if sponsor_id.blank?
          sponsor_username = sponsor_id == 3 ? User.find_morenwm_customer_user.username : users[sponsor_id.to_s][:user_login]

          form_params = { name: I18n.transliterate(user[:display_name].to_s.downcase),
                          sponsor_username: sponsor_username,
                          email: I18n.transliterate(user[:user_email].to_s.downcase),
                          username: user[:user_login],
                          password: SecureRandom.hex }

          form_params[:username] = I18n.transliterate(form_params[:username].to_s.downcase)
          form_params[:username] = form_params[:username] + '2' if User.exists?(username: form_params[:username])

          form = ShortNewRegistrationForm.new(form_params)

          if form.invalid?
            raise "#{user[:sponsor_id]} - #{user[:user_login]} - #{user[:user_email]} - #{form.errors.full_messages.join(', ')}"
          end

          valid_attributes = form.attributes
                                 .except(:sponsor_username, :role, :contract, :g_recaptcha_response)

          User.create!(valid_attributes)
        rescue StandardError => error
          raise error
        end
      end
    end
  end

  task populate_admins: :environment do
    customer_admin = User.find_morenwm_customer_admin
    admins_attributes = [{ username: 'jsonbourne',
                           name: 'Json Bourne',
                           role: :admin,
                           password: '111111',
                           email: 'json.bourne@monetizzecash.com',
                           sponsor: customer_admin },
                         { username: 'brucewayne',
                           name: 'Bruce Wayne',
                           role: :admin,
                           password: '111111',
                           email: 'bruce.wayne@monetizzecash.com',
                           sponsor: customer_admin },
                         { username: 'jeffbezos',
                           name: 'Jeff Bezos',
                           role: :admin,
                           password: '111111',
                           email: 'jeff.bezos@monetizzecash.com',
                           sponsor: customer_admin },
                         { username: 'warrenbuffert',
                           name: 'Warren Buffert',
                           role: :admin,
                           password: '111111',
                           email: 'warren.buffer@monetizecash.com',
                           sponsor: customer_admin },
                         { username: 'markzuckerberg',
                           name: 'Mark Zuckerberg',
                           role: :admin,
                           password: '111111',
                           email: 'mark.zuckerberg@monetizecash.com',
                           sponsor: customer_admin } ]
   ActiveRecord::Base.transaction do
     admins_attributes.each do |attr|
       admin = User.find_by(attr.slice(:email, :username))
       admin = if admin
                 admin.update!(attr)
                 admin
               else
                 User.create!(attr)
               end
     end

     admins_attributes.each do |attr|
       admin = User.find_by(attr.slice(:email, :username))
       admin.try(:binary_node).try(:delete)
     end
   end
  end
end
