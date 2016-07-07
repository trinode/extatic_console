defmodule Extatic.Reporters.Events.Console do
  @behaviour Extatic.Behaviours.EventReporter
  def send(event_list) do
    IO.puts "----------------------------------------------------------------------"
    IO.puts "Console Event Logger:"
    process_events event_list
  end


  def process_events(%{events: event_list}) do

    IO.puts "event_list:"
    IO.inspect event_list


     {errors, remaining} = extract_events(:error, event_list)
     {deployments, remaining} = extract_events(:deployment, remaining)
     {info, remaining} = extract_events(:info, remaining)

     IO.puts "errors:"
     IO.inspect errors

     IO.puts "remaining:"
     IO.inspect remaining

     list_events("Errors, oh noes!", errors)
     list_events("Deployments, nice, probably", deployments)
     list_events("Info, hmmm!", info)

     handle_unknown_events(remaining)
  end

  def list_events(title, events) when length(events) > 0 do
    IO.puts "-------------------------------------------------"
    IO.puts title
    show_items(events)
  end

  def list_events(_title, []), do: nil

  def output_event(event) do
    IO.puts "Type: #{event.type}"
    IO.puts "Title: #{event.title}"
    IO.puts "Level: #{event.level}"
    IO.puts "Content: #{event.content}"
    IO.puts "--"
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

  def show_items([a | b]) do
     output_event(a)
     show_items(b)
  end

  def show_items([]) do
    IO.puts "done with the events, yo"
  end
end
