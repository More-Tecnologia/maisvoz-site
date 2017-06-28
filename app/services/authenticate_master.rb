class AuthenticateMaster

  prepend SimpleCommand

  def initialize(master_pw)
    @master_pw = master_pw
  end

  def call
    if Digest::SHA256.hexdigest(master_pw) == master_digest
      return true
    else
      errors.add(:master_password, 'wrong password')
    end
  end

  private

  attr_reader :master_pw

  def master_digest
    ENV['MASTER_PW']
  end

end
