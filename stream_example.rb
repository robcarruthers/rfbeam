require "unicode_plot"
require "stringio"
require "io/console"
require 'tty-logger'

N = 1000
M = 50

def generate_random_data(n)
  Array.new(n) { rand(-10.0..10.0) }
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

out = StringIO.new
def out.tty?
  true
end

Thread.new { monitor_keypress }
puts "Press 'q' to halt"
loop do
  out.truncate(0)

  plot = UnicodePlot.lineplot(generate_random_data(40), name: "Series 0", width: 120, height: 30)
  UnicodePlot.lineplot!(plot, generate_random_data(40), name: "Series 1", color: :red)
  plot.render(out)

  lines = out.string.lines
  lines.each { |line| $stdout.print "\r#{line}" }
  $stdout.print "\e[0J"
  $stdout.flush
  break if @stop_streaming

  n = lines.count
  $stdout.print "\e[#{n}F"
end