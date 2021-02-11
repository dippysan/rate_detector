# Rate Detector Solution

To run normally:
```
bundle exec ruby ./src/rate_detector.rb volumes.csv 100
```

To run tests:
```
bundle exec rspec
```

## Notes:
- Timezones are ignored
- I've used floats to calculate rate of change, but that will cause problems if fractions are involved. If fractions need to be used, I would use a library like BigDecimal
- I've assumed we can hold all values in memory. If not, I would make the CSV load a lazy enumerator, and chain the other steps together
- The output of the routine on volumes.csv does not include timezones as indicated in your last example. However, my output is consistent with the other examples
- Minimal error checking is done. I would add much more error checking if it were a production system

