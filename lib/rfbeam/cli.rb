# rubocop:disable all
require 'thor'
require 'rfbeam'
require 'tty-table'
require 'tty-logger'
require 'tty-spinner'
require 'io/console'
require 'unicode_plot'

module RfBeam
  class CLI < Thor
  
    attr_accessor :radar, :logger

    desc 'list', 'List available radar modules'
    def list
      logger = TTY::Logger.new
      devices = RfBeam.connected
      logger.warning 'No Radar modules found.' unless devices.count.positive?

      table = TTY::Table.new( header: ['id', 'Path', 'Version'])

      devices.each.with_index do |path, index|
        init_radar(index)
        table << ["#{index}", path, @radar.sw_version]
      end
      puts table.render(:ascii)
    end

    desc 'config <radar_id>', 'Shows the parameter setting for the Radar module'
    def config(radar_id)
      init_radar(radar_id)
      puts @radar.config
    end

    desc 'reset <radar_id>', 'Shows the parameter setting for the Radar module'
    def reset(radar_id)
      init_radar(radar_id)
      @logger.success 'Radar reset to factory defaults' if @radar.reset
    end

    desc 'set_param <radar_id> <key> <value>', 'Set radar parameters, see readme for keys'
    def set_param(radar_id, param, value)
      init_radar radar_id
      return @logger.warn("Invalid param: '#{param}'") unless RfBeam::K_ld7::RADAR_PARAMETERS.include?(param.to_sym)

      @radar.send("#{param}=", value.to_i)
      @logger.success "Set #{@radar.formatted_parameter(param.to_sym)}"
    end

    desc 'ddat <radar_id>', 'stream any valid detections, stop stream with q and enter'
    option :stream, type: :boolean, aliases: '-s', desc: "Stream the data from the device"
    def ddat(radar_id)
      init_radar radar_id
      
      if options[:stream]
        Thread.new { monitor_keypress }
        spinner = TTY::Spinner.new("[:spinner] :title ", format: :bouncing_ball)
        loop do
          break if @stop_streaming
            spinner.spin
            data = @radar.ddat
            spinner.update title: "Searching... #{data[:detection_str]}"
            @logger.success "#{@radar.tdat}" if data[:detection]
        end
        puts "\nTask Quit."
      else
          puts "\n#{@radar.ddat}"
      end

    end

    desc 'pdat <radar_id>', 'Display Tracked Targets'
    def pdat(radar_id)
      init_radar radar_id
      puts @radar.pdat
    end

    desc "rfft <radar_id>", "Display the dopplar radar data as a plot"
    option :stream, type: :boolean, aliases: '-s', desc: "Stream the data from the device"
    option :raw, type: :boolean, aliases: '-r', desc: "Display raw data"
    def rfft(radar_id)
      init_radar(radar_id)

      case
      when options[:stream]
        streamer = RfBeam::KLD7::Streamer.new(@radar)
        streamer.rfft
      when options[:raw]
        print @radar.rfft
      else
        plot = rfft_plot(@radar)
        p plot.render
      end
    end

    private

    def init_radar(id)
      devices = RfBeam.connected
      @logger = TTY::Logger.new
      return @logger.warning 'No Radar modules found.' unless devices.count.positive?

      @radar = RfBeam::K_ld7.new(devices[id.to_i])
    end

    def plot_data(data)
      { x: Array(-128...128), series1: data.shift(256).map { |value| value / 100 }, series2: data.shift(256).map { |value| value.to_i / 100 } }
    end

    def monitor_keypress
      @stop_streaming = false
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
        name: 'IF1/2 Averaged',
        title: 'Raw FFT',
        height: 25,
        width: 120,
        xlabel: "Speed (km/h), #{speed_label}",
        ylabel: 'Signal (db)', xlim: [-128, 128],
        ylim: [0, 100])
      UnicodePlot.lineplot!(plot, data[:x], data[:series2], name: "Threshold")
      plot
    end
  end
end