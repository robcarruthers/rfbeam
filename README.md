# Rfbeam

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rfbeam`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rfbeam

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rfbeam

## Usage

```ruby
❯ bin/console
irb(main):001:0> RfBeam.connected
=> ["/dev/tty.usbserial-FTBX7TKD"]
irb(main):002:0> r = RfBeam::K_ld7.new("/dev/tty.usbserial-FTBX7TKD", 115200)
=> #<RfBeam::K_ld7:0x0000000146bb2ff0 @serial_port=#<Serial:0x0000000146bb2f28 @fd=9, @open=true, @config=#<RubySerial::Posix::Termios:0x0000000146bb2cf8>>>
irb(main):003:0> r.detection?
=> false
irb(main):004:0> r.detection?
=> true
irb(main):005:0> r.tdat
=> {:dist=>68, :speed=>196, :angle=>469, :mag=>6303}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rfbeam.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
