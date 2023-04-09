# Rfbeam

![Gem](https://img.shields.io/gem/v/rfbeam?color=green&label=version)
![Ruby](https://img.shields.io/static/v1?message=Ruby&color=red&logo=Ruby&logoColor=FFFFFF&label=v3.1.2)
![Ruby](https://img.shields.io/gitlab/license/robcarruthers/rfbeam?color=orange)

RfBeam is a simple, high-level interface for the RFBeam radar modules.
The user can query process and raw detection data and set the radar parameters for the sensor.

At this stage it only works on Linux and Mac with the K-LD7 module.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rfbeam

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rfbeam

## Usage

The RfBeam class will return the path of any connected modules

    RfBeam.connected

Simple pass the path and baude rate to initialise a new radar object

    RfBeam::K_ld7.new("/dev/ttyUSB0", 115200) do |radar|
        puts radar.config
    end

## RfBeam::K_ld7 API

### detection?

Returns true if the module has a valid detection.

    radar.detection?
    => true

### ddat

Returns an array with the current detection values

    radar.ddat
    => ["DDAT", 6, 0, 0, 0, 0, 0, 0]

### tdat

Returns a hash with the current tracked object values

    radar.tdat
    => {:dist=>68, :speed=>196, :angle=>469, :mag=>6303}

### grps

Returns the Parameter settings, values map to setting as detailed in the device datasheet.

    radar.grps
    => ["RPST", 42, "K-LD7_APP-RFB-0103", 1, 1, 1, 30, 0, 2, 0, 50, -90, 90, 0, 100, 2, 10, 0, 50, 0, 1, 2, 1, 0, 4]

### config

Returns a formatted String of all parameter settings. The only way to read parameter settings is with config

    radar.config

    Software Version: K-LD7_APP-RFB-0103
    Base Frequency: Low
    Maximum Speed: 100km/h
    Maximum Range: 100m
    Threshold Offset: 30db
    Tracking Filter Type: Long Visibility
    Vibration Suppression: 16
    Minimum Detection Distance: 0%
    Maximum Detection Distance: 100%
    Minimum Detection Angle: -10°
    Maximum Detection Angle: 90°
    Minimum Detection Speed: 0%
    Maximum Detection Speed: 100%
    Detection Direction: Both
    Range Threshold: 10%
    Angle Threshold: 0°
    Speed Threshold: 50%
    Digital Output 1: Direction
    Digital Output 2: Angle
    Digital Output 3: Range
    Hold Time: 1s
    Micro Detection Trigger: Off
    Micro Detection Sensativity: 4

## Parameter API

### Base Frequency

0 = low, 1 = middle (default), 2 = high

alias :rbfr

```ruby
radar.radar.base_frequency = 1
```

### Maximum Speed

0 = 12.5km/h, 1 = 25km/h (default), 2 = 50km/h, 3 = 100km/h, alias :rspi

```ruby
radar.max_speed = 1
```

### Maximum Range

0 = 5m, 1 = 10m (default), 2 = 30m, 3 = 100m, alias :rrai

```ruby
radar.max_range = 1
```

### Threshold Offset

10 - 60db, (default = 30), alias :thof

```ruby
radar.threshold_offset = 30
```

### Tracking filter type

0 = Standard (Default), 1 = Fast Tracking, 2 = Long visibility, alias :trtf

```ruby
radar.tracking_filter = 0
```

### Vibration suppression

0 - 16, 0 = No Suppression, 16 = High Suppression, default = 2, alias :visu

```ruby
radar.vibration_suppression = 2
```

### Minimum Detection distance

0 - 100% of Range setting, default = 0, alias :mira

```ruby
radar.min_detection_distance = 0
```

### Maximum Detection distance

0 - 100% of Range setting, default = 50, alias :mara

```ruby
radar.max_detection_distance = 50
```

### Minimum Detection Angle

-90° - 90°, default = -90, alias :mian

```ruby
radar.min_detection_angle = -90
```

### Maximum Detection Angle

-90° - 90°, default = 90, alias :maan

```ruby
radar.min_detection_angle = 90
```

### Minimum Detection Speed

0 - 100% of Speed setting, default = 0, alias :misp

```ruby
radar.min_detection_speed = 0
```

### Maximum Detection Speed

0 - 100% of Speed setting, default = 100, alias :masp

```ruby
radar.max_detection_speed = 100
```

### Detection Direction

0 = Receding, 1 = Approaching, 2 = Both (default), alias :dedi

```ruby
radar. detection_direction = 2
```

### Range Threshold

0 - 100% of Range setting, default = 10, alias :rath

```ruby
radar. range_threshold = 10
```

### Angle Threshold

-90° to 90°, default = 0, alias :anth

```ruby
radar. range_threshold = 0
```

### Speed Threshold

0 - 100% of speed setting, default = 50, alias :spth

```ruby
radar. angle_threshold = 50
```

### Digital output 1

0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 0

alias :dig1

```ruby
radar.digital_output1 = 0
```

### Digital output 2

0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 1

alias :dig2

```ruby
radar.digital_output2 = 1
```

### Digital output 3

0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 2

alias :dig3

```ruby
radar.digital_output3 = 2
```

### Hold Time

1 - 7200s, default = 1

alias :hold

```ruby
radar.hold_time = 1
```

### Micro Detection retrigger

0 = Off (default), 1 = Retrigger

alias: :mide

```ruby
radar.micro_detection_retrigger = 0
```

### Micro Detection sensitivity

0 - 9, 0 = Min, 9 = Max, default = 4

alias: :mids

```ruby
radar.micro_detection_sensitivty = 4
```

## CLI

``` fish
❯ bundle exec rfbeam list

+--+------------+------------------+
|id|Path        |Version           |
+--+------------+------------------+
|0 |/dev/ttyUSB0|K-LD7_APP-RFB-0103|
+--+------------+------------------+

❯ bundle exec rfbeam help
Commands:
  rfbeam config <radar_id>                   # Shows the parameter setting for the Radar module
  rfbeam ddat <radar_id>  -s, [--stream]     # stream any valid detections, stop stream with q and enter
  rfbeam help [COMMAND]                      # Describe available commands or one specific command
  rfbeam list                                # List available radar modules
  rfbeam pdat <radar_id>                     # Display Tracked Targets
  rfbeam reset <radar_id>                    # Shows the parameter setting for the Radar module
  rfbeam rfft <radar_id>  -s, [--stream]     # Display the dopplar radar data as a plot
  rfbeam set_param <radar_id> <key> <value>  # Set radar parameters, see readme for keys
  rfbeam tdat <radar_id>                     # Display tracked target data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rfbeam.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
