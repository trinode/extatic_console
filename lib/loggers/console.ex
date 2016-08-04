defmodule Extatic.Loggers.Console do

  def send_entry(log_item, %{format: :json}) do
      log_item
      |> Map.delete(:metadata)
      |> Map.merge(log_item.metadata)
      |> Poison.encode!
      |> IO.puts
  end

  def send_entry(log_item, %{format: :text}) do
    IO.puts "#{log_item.timestamp}: #{log_item.message}"
  end

  def send(log_item, %{config: config}) do
     log_item |> send_entry(config)
  end

end
