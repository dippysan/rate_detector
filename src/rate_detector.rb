require 'time'

class RateDetector

  class Value
    attr_reader :timestamp, :volume
    def initialize(timestamp, volume)
      @timestamp = Time.parse(timestamp)
      @volume = volume.to_f
    end
  end

  class ValueChange
    attr_reader :first, :second
    def initialize(first, second)
      @first = first
      @second = second
      @change_per_minute = 0
      if first && second
        @change_per_minute = (second.volume-first.volume).to_f/(second.timestamp-first.timestamp)*60
      end
    end

    def change_over(max)
      @change_per_minute>max
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
      volume_changes.pop # Ignore last entry, which has no .second value

      # Keep only where the volume changes are over max_rate_change
      changes_over_max = volume_changes.select {|v| v.change_over(max_rate_change)}

      # Merge consecutive rows
      merge_consecutive = changes_over_max.reduce([]) do |acc, row|
        if acc.last&.second&.timestamp == row.first.timestamp
          # Merge this with last
          acc.last = ValueCharge.new(acc.last.first, row.last.second)
        else
          acc.push row
        end
        acc
      end
    end
  end
end

