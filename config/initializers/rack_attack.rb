redis = ENV['REDISTOGO_URL'] || 'localhost'
Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(redis)

Rack::Attack.throttle('limit login attempts', limit: 6, period: 60.minutes) do |req|
  req.ip if (req.path == '/users/sign_in' || req.path == '/admin/login') && req.post?
end

Rack::Attack.throttled_response = lambda do |env|
  [503, {}, ["IP bloqueado por 1 hora\n"]]
end

ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  Logger.new(STDOUT).info "[RACK.ATTACK] Blocked request ip=#{req.ip} path=#{req.path}"
end
