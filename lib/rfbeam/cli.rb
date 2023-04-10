# frozen_string_literal: true

require 'thor'
require 'rfbeam'
require 'tty-table'
require 'tty-logger'
require 'tty-spinner'
require 'io/console'
require 'unicode_plot'

module RfBeam
  class CLI < Thor
    attr_accessor :logger

    desc 'list', 'List available radar modules'
    def list
      logger = TTY::Logger.new
      devices = RfBeam.connected
      return logger.warn 'No Radar modules found.' if devices.empty?

      table = TTY::Table.new(header: %w[id Path Version])

      devices.each.with_index { |path, index| table << [index.to_s, path, radar(index).sw_version] }
      puts table.render(:ascii)
    end

    desc 'config <radar_id>', 'Shows the parameter setting for the Radar module'
    def config(radar_id)
      puts radar(radar_id).config
    end

    desc 'reset <radar_id>', 'Shows the parameter setting for the Radar module'
    def reset(radar_id)
      @logger.success 'Radar reset to factory defaults' if radar(radar_id).reset
    end

    desc 'set_param <radar_id> <key> <value>', 'Set radar parameters, see readme for keys'
    def set_param(radar_id, param, value)
      return @logger.warn("Invalid param: '#{param}'") unless Kld7::RADAR_PARAMETERS.include?(param.to_sym)

      r = radar(radar_id)
      r.send("#{param}=", value.to_i)
      @logger.success r.formatted_parameter(param.to_sym)
    end

    desc 'ddat <radar_id>', 'stream any valid detections, stop stream with q and enter'
    option :stream, type: :boolean, aliases: '-s', desc: 'Stream the data from the device'
    def ddat(radar_id)
      cli = RfBeam::Kld7::CliOutput.new(radar_id)
      cli.display(:ddat, stream: options[:stream])
    end

    desc 'pdat <radar_id>', 'Display Tracked Targets'
    def pdat(radar_id)
      cli = RfBeam::Kld7::CliOutput.new(radar_id)
      cli.display(:pdat, stream: options[:stream])
    end

    desc 'rfft <radar_id>', 'Display the dopplar radar data as a plot'
    option :stream, type: :boolean, aliases: '-s', desc: 'Stream the data from the device'
    option :raw, type: :boolean, aliases: '-r', desc: 'Display raw data'
    def rfft(radar_id)
      plotter = RfBeam::Kld7::CliOutput.new(radar_id)
      if options[:raw]
        print radar(radar_id).rfft
      else
        plotter.plot(:rfft, stream: options[:stream])
      end
    end

    desc 'tdat <radar_id>', 'Display tracked target data'
    def tdat(radar_id)
      cli = RfBeam::Kld7::CliOutput.new(radar_id)
      cli.display(:tdat, stream: options[:stream])
    end

    private

    def radar(id)
      devices = RfBeam.connected
      @logger = TTY::Logger.new
      return @logger.warning 'No Radar modules found.' unless devices.count.positive?

      RfBeam::KLD7.new(devices[id.to_i])
    end
  end
end
