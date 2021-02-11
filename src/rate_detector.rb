require 'time'
require 'csv'

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
        @change_per_minute = ((second.volume-first.volume).to_f/(second.timestamp-first.timestamp)*60).abs
      end
    end

    def self.header
      "Start Timestamp,End Timestamp,Start Volume,End Volume\n"
    end

    def change_over(max)
      @change_per_minute>max.to_i
    end

    def as_csv
      "%s,%s,%d,%d\n" % [
        first.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
        second.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
        first.volume,
        second.volume]
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

      volume_changes = input_array.each_cons(2).map do |first, second|
        ValueChange.new(first, second)
      end

      # Keep only where the volume changes are over max_rate_change
      changes_over_max = volume_changes.select {|v| v.change_over(max_rate_change)}

      # Merge consecutive rows
      merge_consecutive = changes_over_max.reduce([]) do |acc, current|
        prev = acc.last
        if prev&.second&.timestamp == current.first.timestamp
          # Merge this with last
          acc[-1] = ValueChange.new(prev.first, current.second)
        else
          acc.push current
        end
        acc
      end

      output_csv = ValueChange.header+merge_consecutive.map(&:as_csv).join
    end
  end
end

# Run from command line
if !ENV['RACK_ENV']
  raise "Usage: ./rate_detector.rb <csv_file> <rate_of_change>" if ARGV.length<2

  max_rate_change = ARGV[1].to_i
  csv = File.read(ARGV[0])
  puts RateDetector.call(max_rate_change, csv)
end
