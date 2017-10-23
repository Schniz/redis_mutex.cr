require "./spec_helper"
require "../src/redis_mutex"

class CustomException < Exception
end

describe RedisMutex do
  it "works" do
    50.times do
      start_time = Time.now
      channel = Channel(Int32).new

      spawn do
        RedisMutex::Lock.new("MY_KEY").run do
          sleep 0.2
          channel.send(1)
        end
      end

      sleep 0.1

      spawn do
        RedisMutex.run("MY_KEY") do
          channel.send(2)
        end
      end

      values = [] of Int32
      2.times { values << channel.receive }

      values.should eq([1, 2])
    end
  end

  it "clears token on exception" do
    redis = Redis.new
    redis.get("MY_KEY").should eq nil
    expect_raises(CustomException) do
      begin
        RedisMutex::Lock.new("MY_KEY").run { raise CustomException.new }
      ensure
        redis.get("MY_KEY").should eq nil
      end
    end
  end
end
