defmodule Extatic.Reporters.Metrics.Console do
  @behaviour Extatic.Behaviours.MetricReporter
  def send(state = %{metrics: metrics}) when length(metrics) > 0 do
    show_items metrics, state
  end

  def send(_), do: nil

  def show_items([a | b], state = %{config: %{format: :json}}) do
     a
     |> format_time
     |> Poison.encode!
     |> IO.puts

     show_items(b, state)
  end

  defp format_time(metric) do
    time = timestamp(metric.timestamp)
    Map.put(metric,:timestamp,time)
  end

  defp timestamp(ts) do
    ts
    |> DateTime.from_unix!(:microseconds)
    |> DateTime.to_string
  end

  def show_items(_,_), do: nil
end
