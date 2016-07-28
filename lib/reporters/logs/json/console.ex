defmodule Extatic.Reporters.Logs.Json.Console do
  use GenEvent

  def init(__MODULE__) do
    {:ok, %{config: get_config}}
  end

  def handle_event({level, _group_lead, {Logger, msg, ts, mdata}}, %{config: %{metadata: metadata, level: min_level}} = state) do
    if is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt do
      event = %{
        time: timestamp(ts),
        level: level,
        metadata: mdata |> Enum.into(metadata) |> Map.drop([:pid]),
        message: msg |> to_string
      } |> Poison.encode!

      IO.puts(event)
    end

    {:ok, state}
  end

  defp get_config do
    Application.get_env(:logger, :json_logger, []) |> Enum.into(%{})
  end

  defp timestamp({{yr, mth, day},{hr, min, sec, ms}}) do
    with {:ok, date_time} <- NaiveDateTime.new(yr, mth, day, hr, min, sec, ms),
    do:  date_time |> NaiveDateTime.to_iso8601
  end
end
