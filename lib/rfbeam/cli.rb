require 'thor'
require 'rfbeam'
require 'tty-table'
require 'tty-spinner'
require 'io/console'

module RfBeam
  class CLI < Thor
    desc 'list', 'List available radar modules'

    def list
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      table = TTY::Table.new( header: ['id', 'Path', 'Version'])

      devices.each.with_index do |path, index|
        radar = RfBeam::K_ld7.new(path, 115200)
        table << ["R#{index}", path, radar.sw_version]
      end
      puts table.render(:ascii)
    end

    desc 'config <id>', 'Shows the parameter setting for the Radar module'
    def config(radar_id)
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      RfBeam::K_ld7.new(devices[radar_id.to_i], 115200) do |radar|
        puts radar.config
      end
    end

    desc 'set_param <id> <key> <value>', 'Set radar parameters, see readme for keys'
    def set_param(index, param, value)
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      RfBeam::K_ld7.new(devices[index.to_i], 115200) do |radar|
        puts radar.send("#{param}=", value.to_i)
      end
    end

    desc 'ddat <id>', 'stream any valid detections, stop stream with q and enter'
    def ddat(index)
      spinner = TTY::Spinner.new("[:spinner] :title ", format: :arrow_pulse)
      devices = RfBeam.connected

      RfBeam::K_ld7.new(devices[index.to_i], 115200) do |radar|
        loop do
          spinner.spin
          data = radar.ddat
          spinner.update title: "Searching... ddat = #{data}"
          if data[2] == 1
            spinner.success data
          end
        # Check for input to terminate the task
          if IO.select([$stdin], [], [], 0)
            input = $stdin.getch
            break if input == 'q' || input == 'Q' || input == 'exit'
          end
        end
      end

      spinner.stop
      puts "\nTask Quit."
    end
  end
end