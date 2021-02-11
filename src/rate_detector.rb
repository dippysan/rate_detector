require 'time'

class RateDetector

  class Value
    attr_reader :timestamp, :volume
    def initialize(timestamp, volume)
      @timestamp = Time.parse(timestamp)
      @volume = volume
    end
  end

  class ValueChange
    attr_reader :first, :second
    def initialize(first, second)
      @first = first
      @second = second
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
      volume_changes = input_array.each_slice(2).map do |first, second|
        ValueChange.new(first, second)
      end
    end
  end
end

