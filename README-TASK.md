## Veridapt Rate Detector Take Home Exercise

The included CSV file contains a list of volume readings.  Each of the CSV entries contains two values, the timestamp when the  volume was read, and the actual volume in litres. The CSV file is  ordered by the reading's timestamp.

You are going to create a  small application in Ruby that reads this CSV file and finds the periods of time when the volume changes at a rate greater than a user defined  volume.

The first parameter to the script is the path to the CSV  file, and the second parameter is an integer value representing the rate of change:

`
ruby rate_detector.rb <csv_file> <rate_of_change>
`

For example:

`
ruby rate_detector.rb volumes.csv 100
`

The rate of change is passed to the script in litres **per minute**.

The script will output, to stdout, a comma separated list of time periods  where the changes in volume were greater than the rate of change. Note  that we are interested in the change in volume **as an absolute value**, as it could be either positive or negative.

The format of the output CSV should be:

`
Start Timestamp,End Timestamp,Start Volume,End Volume
`

For example, given an input CSV containing the data below:

```
Timestamp,Volume
2019-04-29 10:03:00,9100
2019-04-29 10:04:00,9400
2019-04-29 10:10:00,9700
```

and assuming the desired rate of change is 100, the rate  of change between the first two entries is 300 litres per minute. The  2nd and 3rd entries only have a rate of change of 50 litres per minute  between them.

Hence, the output CSV output should be:

```
Start Timestamp,End Timestamp,Start Volume,End Volume
2019-04-29 10:03:00,2019-04-29 10:04:00,9100,9400
```

If there are consecutive groups of entries that meet the  rate of change criteria, these should be "merged". For example, given  the input CSV containing:

```
Timestamp,Volume
2019-04-29 10:03:00,9100
2019-04-29 10:04:00,9400
2019-04-29 10:10:00,10600
```

the output CSV should be:

```
Start Timestamp,End Timestamp,Start Volume,End Volume
2019-04-29 10:03:00,2019-04-29 10:10:00,9100,10600
```



The expected output from running the program against the supplied example CSV should be:

```
ruby rate_detector.rb volumes.csv 100
Start Timestamp,End Timestamp,Start Volume,End Volume
2019-04-29` `10:03:20` `+1000,2019-04-29` `10:10:00` `+1000,9100,11200
2019-04-29` `10:10:20` `+1000,2019-04-29` `10:14:00` `+1000,11200,11000
2019-04-29` `10:16:00` `+1000,2019-04-29` `10:19:00` `+1000,11020,7000
```