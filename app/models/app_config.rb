class AppConfig

  def self.get(key)
    ENV.fetch(key.to_s.upcase)
  end

  def self.is?(key)
    %(true 1 t).include?(ENV.fetch(key))
  end

end
