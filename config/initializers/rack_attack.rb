Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(ENV.fetch('REDIS_URL', 'localhost'))

# Rack::Attack.throttle('limit login attempts', limit: 6, period: 60.minutes) do |req|
#   req.params['user']['login'] if req.path == '/users/sign_in' && req.post?
# end

Rack::Attack.throttle('limit admin login attempts', limit: 6, period: 60.minutes) do |req|
  req.params['admin_user']['login'] if req.path == '/admin/login' && req.post?
end

Rack::Attack.throttled_response = lambda do |env|
  [503, {}, ["IP bloqueado por 1 hora\n"]]
end

ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  Logger.new(STDOUT).info "[RACK.ATTACK] Blocked request ip=#{req.ip} path=#{req.path}"
end
