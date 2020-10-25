ActiveRecord::Base.transaction do
  financial_admin_user = User.find_morenwm_customer_admin

  adminfinancial_user = User.create!(username: 'admintwo',
                                     name: 'Daniel',
                                     role: :admin,
                                     password: '111111',
                                     email: 'publimoneyd@gmail.com',
                                     sponsor: financial_admin_user)

  adminfinancial_user = User.create!(username: 'admthree',
                                     name: 'Adm three',
                                     role: :admin,
                                     password: '111111',
                                     email: 'negociosdigitalesbitcoin@gmail.com',
                                     sponsor: financial_admin_user)

  adminfinancial_user = User.create!(username: 'adminfour',
                                     name: 'Giovany',
                                     role: :admin,
                                     password: '111111',
                                     email: 'moscosojonathan1304@gmail.com',
                                     sponsor: financial_admin_user)
end
