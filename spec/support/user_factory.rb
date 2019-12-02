class UserFactory

  def self.create
    more_user = User.new(username: ENV['MORENWM_USERNAME'],
                         name: ENV['MORENWM_USERNAME'],
                         role: 'admin',
                         password: '111111',
                         email: 'morenwm@morenwm.com')
    more_user.save(validate: false)
  end


end
