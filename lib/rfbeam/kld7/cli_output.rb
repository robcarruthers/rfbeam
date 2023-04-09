# frozen_string_literal: true

require 'unicode_plot'
require 'io/console'
require 'stringio'
require 'tty-screen'
require 'tty-logger'

module RfBeam
  module Kld7
    class CliOutput
      attr_reader :radar

      def initialize(radar_id)
        devices = RfBeam.connected
        return TTY::Logger.new.warning 'No Radar modules found.' unless devices.count.positive?

        @radar = RfBeam::KLD7.new(devices[radar_id.to_i])
      end

      def display(type, stream: false)
        send("display_#{type}", stream)
      end

      def plot(type, stream: false)
        stream ? stream_plot(type) : display_plot(type)
      end

      def display_plot(type)
        out = StringIO.new
        def out.tty?
          true
        end
        out.truncate(0)

        plot = send("#{type}_plot")
        plot.render(out)

        lines = out.string.lines
        lines.each { |line| $stdout.print "\r#{line}" }
        $stdout.print "\e[0J"
        $stdout.flush

        return unless @streaming

        n = lines.count
        $stdout.print "\e[#{n}F"
      end

      def stream_plot(type)
        @streaming = true
        Thread.new { monitor_keypress }

        loop do
          display_plot(type)
          break unless @streaming
        end
      end

      private

      def monitor_keypress
        loop do
          key = $stdin.getch
          if key.downcase == 'q'
            @streaming = false
            break
          end
        end
      end

      def rfft_plot_data(data)
        {
          x: Array(-128...128),
          series1: data.shift(256).map { |value| value / 100 },
          series2: data.shift(256).map { |value| value.to_i / 100 }
        }
      end

      def display_ddat(stream)
        data = @radar.ddat
        if stream
          @streaming = true
          Thread.new { monitor_keypress }
          spinner = TTY::Spinner.new('[:spinner] :title ', format: :bouncing_ball)
          logger = TTY::Logger.new
          loop do
            break unless @streaming

            spinner.spin
            spinner.update title: "Detection: #{DETECTION_FLAGS[data[2]]}"
            logger.success @radar.tdat.to_s unless data[2].zero?
          end
        else
          puts RfBeam::Kld7::CliFormatter.new.ddat(data)
        end
      end

      def display_tdat(stream)
        puts RfBeam::Kld7::CliFormatter.new.tdat(@radar.tdat)
      end

      def display_pdat(stream)
        table = RfBeam::Kld7::CliFormatter.new.pdat_table(@radar.pdat)
        puts "\n   Detected Raw Targets"
        puts table.render(:unicode, alignment: :center)
      end

      def rfft_plot
        screen_width = TTY::Screen.width * 0.65
        data = rfft_plot_data(@radar.rfft)
        plot =
          UnicodePlot.lineplot(
            data[:x],
            data[:series1],
            name: 'IF1/2 Averaged',
            title: 'Raw FFT',
            height: 25,
            width: screen_width,
            xlabel: 'Speed (km/h)',
            ylabel: 'Signal (db)',
            xlim: [-128, 128],
            ylim: [0, 100]
          )
        UnicodePlot.lineplot!(plot, data[:x], data[:series2], name: 'Threshold')
        plot
      end
    end
  end
end
