require 'redis'

redis_config = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }
begin
  $redis = Redis.new(redis_config)
rescue Exception => e
  puts e
end
