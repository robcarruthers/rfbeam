# rubocop:disable all
require "unicode_plot"
require "io/console"

def generate_random_data(n)
  Array.new(n) { rand(-10.0..10.0) }
end

def update_data(plot, series1, series2)
  plot.series_list[0].data.y = series1
  plot.series_list[1].data.y = series2
  plot.auto_calc_ylim
end

def start
  Thread.new { monitor_keypress }
  loop do
    break if @stop_streaming
    display_plot
    sleep period
  end
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

def plot_demo
  out = StringIO.new
  out.truncate(0)
  plot =
    UnicodePlot.lineplot(
      generate_random_data(40),
      name: "Series 0",
      width: 40,
      height: 10
    )

  UnicodePlot.lineplot!(
    plot,
    generate_random_data(40),
    name: "Series 1",
    color: :red
  )
  UnicodePlot.lineplot!(
    plot,
    generate_random_data(40),
    name: "Series 2",
    color: :blue
  )
  puts plot.render(out)

  Thread.new { monitor_keypress }

  loop do
    break if @stop_streaming

    lines = out.string.lines
    lines.each { |line| $stdout.print "\r#{line}" }
    $stdout.print "\e[0J"
    $stdout.flush
  end
end

plot_demo
