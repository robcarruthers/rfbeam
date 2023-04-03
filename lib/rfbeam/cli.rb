require 'thor'
require 'rfbeam'
require 'tty-table'
require 'tty-spinner'
require 'io/console'
require 'unicode_plot'

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

    desc 'config <radar_id>', 'Shows the parameter setting for the Radar module'
    def config(radar_id)
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      RfBeam::K_ld7.new(devices[radar_id.to_i], 115200) do |radar|
        puts radar.config
      end
    end

    desc 'set_param <radar_id> <key> <value>', 'Set radar parameters, see readme for keys'
    def set_param(index, param, value)
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      RfBeam::K_ld7.new(devices[index.to_i], 115200) do |radar|
        puts radar.send("#{param}=", value.to_i)
      end
    end

    desc 'ddat <radar_id>', 'stream any valid detections, stop stream with q and enter'
    def ddat(index)
      spinner = TTY::Spinner.new("[:spinner] :title ", format: :bouncing_ball)
      devices = RfBeam.connected

      RfBeam::K_ld7.new(devices[index.to_i], 115200) do |radar|
      Thread.new { monitor_keypress }
        loop do
          break if @stop_streaming
          spinner.spin
          data = radar.ddat
          spinner.update title: "Searching... ddat = #{data}"
          if data[2] == 1
            spinner.success radar.tdat
          end
        end
      end

      spinner.stop
      puts "\nTask Quit."
    end

    desc 'pdat <radar_id>', 'Display Tracked Targets'
    def pdat(index)
      devices = RfBeam.connected

      RfBeam::K_ld7.new(devices[index.to_i], 115200) do |radar|
        puts radar.pdat
      end
    end

    desc "rfft <radar_id>", "Display the dopplar radar data as a plot"
    option :stream, type: :boolean, aliases: '-s', desc: "Stream the data from the device"
    option :period, type: :numeric, aliases: '-p', default: 0.5, desc: "Update period (in seconds) for the streaming data"
    def rfft(index)
      devices = RfBeam.connected
      return puts 'No Radar modules found.' unless devices.count.positive?

      radar = RfBeam::K_ld7.new(devices[index.to_i], 115200)
      plot = rfft_plot(radar)
      puts plot.render
      # if options[:stream]
      #   streamer = RadarDataStreamer.new(options[:period])
      #   streamer.start
      # else
      #   display_plot(plot_data(data))
      # end
    end

    private

    def plot_data(data)
      { x: Array(-128...128), series1: data.shift(256).map { |value| value / 100 }, series2: data.shift(256).map { |value| value.to_i / 100 } }
    end

    def monitor_keypress
      loop do
        key = STDIN.getch
        if key.downcase == 'q'
          @stop_streaming = true
          break
        end
      end
    end

    def rfft_plot(radar)
      speed = radar.max_speed
      speed_label = radar.formatted_parameter(:max_speed)
      xlim = [speed - speed * 2, speed]
      data = plot_data(radar.rfft)
      plot = UnicodePlot.lineplot(
        data[:x],
        data[:series1],
        title: 'Raw FFT',
        height: 25,
        width: 120,
        xlabel: "Speed (km/h), #{speed_label}",
        labels: ['test', 'asdf'],
        ylabel: 'Signal (db)', xlim: [-128, 128],
        ylim: [0, 100])
      UnicodePlot.lineplot!(plot, data[:x], data[:series2], name: "Threshold")
      plot
    end
  end
end