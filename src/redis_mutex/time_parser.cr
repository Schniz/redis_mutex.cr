class RedisMutex::TimeParser
  def self.parse(value)
    if value.nil?
      Time.epoch(0)
    else
      Time.epoch(value.to_i)
    end
  end
end
