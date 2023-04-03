require 'unicode_plot'
require 'io/console'

module RfBeam
  class RadarDataStreamer
    attr_reader :period
    attr_accessor :plot

    def initialize(period)
      @period = period
    end

    def start
      Thread.new { monitor_keypress }
      loop do
        break if @stop_streaming
        display_plot
        sleep period
      end
    end

    private

    def monitor_keypress
      loop do
        key = STDIN.getch
        if key.downcase == 'q'
          @stop_streaming = true
          break
        end
      end
    end

    def display_plot
      system('clear')
      # Replace the following lines with code to query the dopplar radar for raw sensor data
      x = Array(-128..127)
      s1 = Array.new(256) { rand(0..100) }
      s2 = Array.new(256) { 35 }

      @plot = UnicodePlot.lineplot(x,s1, xlabel: 'Speed', ylabel: 'Signal', xlim: [-100, 100], ylim: [0, 100])
      UnicodePlot.lineplot!(@plot,x, s2, name: "Threshold")
      @plot.render

    end
  end
end