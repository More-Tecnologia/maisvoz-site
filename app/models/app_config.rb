class AppConfig

  def self.get(key)
    ENV.fetch(key.to_s.upcase)
  end

end
