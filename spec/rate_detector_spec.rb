require_relative '../src/rate_detector'
require 'spec_helper'
require 'csv'

RSpec.describe 'integration' do

  describe RateDetector do

    it "Example 1 - Output large changes in volume" do

      input = <<~CSV
        Timestamp,Volume
        2019-04-29 10:03:00,9100
        2019-04-29 10:04:00,9400
        2019-04-29 10:10:00,9700
      CSV

      output = <<~CSV
        Start Timestamp,End Timestamp,Start Volume,End Volume
        2019-04-29 10:03:00,2019-04-29 10:04:00,9100,9400
      CSV

      expect(RateDetector.call(100,input)).to eq output
    end

    it "Example 2 - Merge Sequential" do

      input = <<~CSV
        Timestamp,Volume
        2019-04-29 10:03:00,9100
        2019-04-29 10:04:00,9400
        2019-04-29 10:10:00,10600
      CSV

      output = <<~CSV
        Start Timestamp,End Timestamp,Start Volume,End Volume
        2019-04-29 10:03:00,2019-04-29 10:10:00,9100,10600
      CSV

      expect(RateDetector.call(100,input)).to eq output
    end

    it "Example 3 - volume.csv" do

      input = File.read('./volumes.csv')

      output = <<~CSV
        Start Timestamp,End Timestamp,Start Volume,End Volume
        2019-04-29 10:03:20,2019-04-29 10:10:00,9100,11200
        2019-04-29 10:10:20,2019-04-29 10:14:00,11200,11000
        2019-04-29 10:16:00,2019-04-29 10:19:00,11020,7000
      CSV

      expect(RateDetector.call(100,input)).to eq output
    end
  end
end




