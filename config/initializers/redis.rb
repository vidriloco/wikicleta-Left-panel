require 'redis'
require 'redis/objects'
redis_config = Psych.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
Redis.current = Redis.connect(:url => redis_config["url"])
