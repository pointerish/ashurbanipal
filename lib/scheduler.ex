defmodule Ashurbanipal.Scheduler do
  @moduledoc """
  A GenServer to schedule the retrieval of HN Top stories every 5 minutes
  """

  use GenServer

  alias Ashurbanipal.Stories
  alias Ashurbanipal.HNClient

  @five_minutes_in_milliseconds 300_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    populate_ets_table()
    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    init(state)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work, do: Process.send_after(self(), :work, @five_minutes_in_milliseconds)

  defp populate_ets_table do
    case HNClient.get_stories_data() do
      {:error, :hn_api_error} ->
        GenServer.call(Stories, {:put, "stories", nil})
      stories ->
        GenServer.call(Stories, {:put, "stories", stories})
    end
  end
end
