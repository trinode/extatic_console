defmodule ExtaticReportersMetricsConsoleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "It outputs noting if there is no metrics key" do
    output = capture_io(fn ->
      Extatic.Reporters.Metrics.Console.send(%{})
    end)

    assert output == ""
  end

  test "It outputs noting if there is an empty metrics list" do
    output = capture_io(fn ->
      Extatic.Reporters.Metrics.Console.send(%{metrics: []})
    end)

    assert output == ""
  end

  test "It outputs the metric if one is present" do
    output = capture_io(fn ->
      Extatic.Reporters.Metrics.Console.send(%{metrics: [%{name: "metric1", value: "7", timestamp: 1451606400000000}], config: %{format: :json}})
    end)

    assert output == "{\"value\":\"7\",\"timestamp\":\"2016-01-01 00:00:00.000000Z\",\"name\":\"metric1\"}\n"
  end
end
