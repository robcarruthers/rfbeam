# rubocop:disable all
require "unicode_plot"
require "io/console"
require "stringio"
require "tty-screen"

module RfBeam
  module KLD7
    class Streamer
      attr_accessor :radar

      def initialize(radar)
        @radar = radar
      end

      def monitor_keypress
        loop do
          key = STDIN.getch
          if key.downcase == "q"
            @stop_streaming = true
            break
          end
        end
      end

      def rfft
        out = StringIO.new
        def out.tty?
          true
        end

        Thread.new { monitor_keypress }

        loop do
          out.truncate(0)

          plot = rfft_plot(@radar)
          plot.render(out)

          lines = out.string.lines
          lines.each { |line| $stdout.print "\r#{line}" }
          $stdout.print "\e[0J"
          $stdout.flush
          break if @stop_streaming

          n = lines.count
          $stdout.print "\e[#{n}F"
        end
      end

      private

      def plot_data(data)
        {
          x: Array(-128...128),
          series1: data.shift(256).map { |value| value / 100 },
          series2: data.shift(256).map { |value| value.to_i / 100 }
        }
      end

      def rfft_plot(radar)
        width = TTY::Screen.width * 0.65
        data = plot_data(radar.rfft)
        plot =
          UnicodePlot.lineplot(
            data[:x],
            data[:series1],
            name: "IF1/2 Averaged",
            title: "Raw FFT",
            height: 25,
            width: width,
            xlabel: "Speed (km/h)",
            ylabel: "Signal (db)",
            xlim: [-128, 128],
            ylim: [0, 100]
          )
        UnicodePlot.lineplot!(plot, data[:x], data[:series2], name: "Threshold")
        plot
      end
    end
  end
end
