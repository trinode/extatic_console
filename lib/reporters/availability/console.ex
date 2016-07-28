defmodule Extatic.Reporters.Availability.Console do
  @behaviour Extatic.Behaviours.AvailabilityReporter
  def send(_state) do
    IO.puts "App is alive!"
  end
end
