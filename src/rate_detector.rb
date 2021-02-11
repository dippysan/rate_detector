require 'time'

class RateDetector

  class Value
    attr_reader :timestamp, :volume
    def initialize(timestamp, volume)
      @timestamp = Time.parse(timestamp)
      @volume = volume
    end
  end

  class << self

    def parse(csv)
      CSV.parse(csv, headers: true).map do |row|
        Value.new(row["Timestamp"], row["Volume"])
      end
    end

    def call(max_rate_change, input_csv)
      input_array = parse(input_csv)
    end
  end
end

