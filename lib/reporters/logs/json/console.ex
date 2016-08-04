defmodule Extatic.Reporters.Logs.Json.Console do
  use GenEvent

  def init({__MODULE__, name}) do
    {:ok, get_config(name)}
  end

  def handle_event(data = {level, _grp_lead, {Logger, _msg, _ts, mdata}}, state = %{metadata: metadata, level: min_level}) do
    if log_event?(level, min_level) do
      data
      |> format
      |> merge_metadata(mdata, metadata)
      |> Poison.encode!
      |> IO.puts
    end

    {:ok, state}
  end

  defp merge_metadata(data, mdata, metadata) do
    mdata
    |> Enum.into(metadata)
    |> Map.drop([:pid])
    |> Map.merge(data)
  end

  defp format({level, _, {_, msg, ts, _}}) do
    %{
      time: timestamp(ts),
      level: level,
      message: msg |> to_string
    }
  end

  def log_event?(level, min_level) do
    is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt
  end

  defp get_config(name) do
    Application.get_env(:logger, name, []) |> Enum.into(%{})
  end

  defp timestamp({{yr, mth, day},{hr, min, sec, ms}}) do
    with {:ok, date_time} <- NaiveDateTime.new(yr, mth, day, hr, min, sec, ms),
    do:  date_time |> NaiveDateTime.to_iso8601
  end
end
