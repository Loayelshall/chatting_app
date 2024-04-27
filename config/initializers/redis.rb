require 'redis'

redis_config = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }
begin
  $redis = Redis.new(redis_config)
rescue Exception => e
  puts e
end

begin
  $redis_lock = Redlock::Client.new([ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }])
rescue Exception => e
  puts e
end
