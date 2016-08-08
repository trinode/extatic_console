defmodule ExtaticReportersEventsConsoleTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  test "It outputs nothing if there is no event key" do
    output = capture_log(fn ->
      Extatic.Reporters.Events.Console.send(%{})
    end)
    assert output == ""
  end

  test "It outputs nothing if there are no events in the list" do
    output = capture_log(fn ->
      Extatic.Reporters.Events.Console.send(%{events: []})
    end)
    assert output == ""
  end

  test "It outputs an event if there is an event in the list" do
    output = capture_log(fn ->
      Extatic.Reporters.Events.Console.send(%{events: [%{type: :error, title: "test event", content: "test content"}]})
    end)
    assert output =~ "[error] {\"type\":\"error\",\"title\":\"test event\",\"content\":[\"test content\"]}\n"
  end

  test "It outputs multiple events if there are more than one event in the list" do
    output = capture_log(fn ->
      Extatic.Reporters.Events.Console.send(%{events: [%{type: :error, title: "test event", content: "test content"},%{type: :info, title: "test event2", content: "test content2"}]})
    end)
    assert output =~ "[error] {\"type\":\"error\",\"title\":\"test event\",\"content\":[\"test content\"]}\n"
    assert output =~ "[info]  {\"type\":\"info\",\"title\":\"test event2\",\"content\":[\"test content2\"]}\n"
  end
end
