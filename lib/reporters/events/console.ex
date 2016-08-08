defmodule Extatic.Reporters.Events.Console do
  require Logger
  @behaviour Extatic.Behaviours.EventReporter
  def send(event_list) do
    # IO.puts "----------------------------------------------------------------------"
    # IO.puts "Console Event Logger:"
    process_events event_list
  end


  def process_events(%{events: event_list}) do

    # IO.puts "event_list:"
    # IO.inspect event_list


     {errors, remaining} = extract_events(:error, event_list)
     {deployments, remaining} = extract_events(:deployment, remaining)
     {info, remaining} = extract_events(:info, remaining)

    #  IO.puts "errors:"
    #  IO.inspect errors
     #
    #  IO.puts "remaining:"
    #  IO.inspect remaining

     list_events("Errors", errors, :error)
     list_events("Deployments", deployments, :info)
     list_events("Info", info, :info)

     handle_unknown_events(remaining)
  end

  def process_events(_), do: nil

  def list_events(title, events, level) when length(events) > 0 do
    show_items(events, level)
  end

  def list_events(_title, [], _level), do: nil

  def output_event(event, level) do
    content = event.content |> String.split("\n")
    event = Map.put(event,:content, content)

    event = Poison.encode!(event)
    Logger.log(level, event)
  end


  def handle_unknown_events(list) when length(list) > 0 do
    IO.puts "some unknown events!"
  end

  def handle_unknown_events([]), do: nil

  def extract_events(type, event_list) do
    found = Enum.filter(event_list, fn item -> item.type == type end)
    remaining = Enum.filter(event_list, fn item -> item.type != type end)
    {found, remaining}
  end

  def show_items([a | b], level) do
     output_event(a, level)
     show_items(b, level)
  end

  def show_items([], _level) do
  end
end
