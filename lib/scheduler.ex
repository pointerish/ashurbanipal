defmodule Ashurbanipal.Scheduler do
  @moduledoc """
  A GenServer to schedule the retrieval of HN Top stories
  """

  use GenServer

  alias Ashurbanipal.Stories
  alias Ashurbanipal.HNClient

  @five_minutes_in_milliseconds 300_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    stories = HNClient.get_stories_data()
    GenServer.call(Stories, {:put, "stories", stories})
    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    init(state)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work, do: Process.send_after(self(), :work, @five_minutes_in_milliseconds)
end
