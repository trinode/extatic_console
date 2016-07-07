defmodule Extatic.Reporters.Metrics.Console do
  @behaviour Extatic.Behaviours.MetricReporter
  def send(stat_list) do
    IO.puts "----------------------------------------------------------------------"
    IO.puts "Console Metric Logger:"
    show_items stat_list
  end

  def show_items([a | b]) do
     IO.inspect a
     show_items(b)
  end

  def show_items([]) do
    IO.puts "done with the metrics, yo"
  end
end
