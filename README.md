# Rfbeam

RfBeam is a simple, high-level interface to the RFBeam radar modules.
The user can read and set the radar parameters and fetch raw or processed data frames from the sensor.

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

Returns a formatted String of all parameter settings

    radar.config

    Software Version: K-LD7_APP-RFB-0103
    Base Frequency: Middle
    Max Speed: 25km/h
    Max Range: 10m
    Threshold offset: 30db
    Tracking Filter Type: standard
    Vibration Suppression: 2 , (0-16, 0 = No Suppression, 16 = High Suppression)
    Minimum Detection Distance: 0 , (0 - 100% of range setting)
    Maximum Detection Distance: 50 , (0 - 100% of range setting)
    Minimum Detection Angle: -90° , (-90° - 90°)
    Maximum Detection Angle: 90° , (0 - 100% of range setting)
    Maximum Detection Speed: 0 , (0 - 100% of speed setting)
    Maximum Detection Speed: 100 , (0 - 100% of speed setting)
    Detection Direction: 2Range Threshold: 10%, (0 - 100% of range setting)
    Angle Threshold: 0°, (-90° - 90°)
    Speed Threshold: 50%, (0 - 100% of speed setting)
    Digital output 1: Direction
    Digital output 2: Angle
    Digital output 3: Range
    Hold time: 1sec
    Micro Detection Retrigger: Off
    Micro Detection Sensitivity: 4 (0 - 9, 0 = Min, 9 = Max)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rfbeam.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
