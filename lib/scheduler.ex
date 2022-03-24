defmodule Ashurbanipal.Scheduler do
  use GenServer

  @five_minutes_in_milliseconds 300_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @five_minutes_in_milliseconds)
  end
end
