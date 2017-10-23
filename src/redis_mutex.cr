require "./redis_mutex/lock"

module RedisMutex
  MAX_LOCKING_TIME = 2.seconds

  def self.run(*args, **kwargs, &block)
    Lock.new(*args, **kwargs).run(&block)
  end
end
