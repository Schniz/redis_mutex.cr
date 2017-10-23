require "./spec_helper"
require "../src/redis_mutex"

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

      expect(values).to eq([1, 2])
    end
  end
end
