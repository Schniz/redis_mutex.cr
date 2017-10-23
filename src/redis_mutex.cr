require "./redis_mutex/lock"

# Distributed mutex on top of Redis
module RedisMutex
  # Time wait until assuming deadlock and ignoring the lock
  MAX_LOCKING_TIME = 2.seconds

  # Creates a new instance of `Redis::Mutex` and executes
  # the given block with a distributed mutex on top of Redis
  def self.run(*args, **kwargs, &block)
    Lock.new(*args, **kwargs).run(&block)
  end
end
