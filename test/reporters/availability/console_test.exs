defmodule ExtaticReportersAvailabilityConsoleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "It outputs a status message" do
    output = capture_io(fn ->
      Extatic.Reporters.Availability.Console.send(%{})
    end)
    
    assert output == "App is alive!\n"
  end
end
