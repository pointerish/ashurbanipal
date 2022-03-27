defmodule Ashurbanipal.Stories do
  @moduledoc """
  A module to initialize a :stories ETS table at application init

  The idea of creating a GenServer to wrap the ETS operations I need was taken from here:
  https://elixirforum.com/t/ets-created-on-application-init/21608

  I love the Elixir community. ;)
  """
  use GenServer

  @impl true
  def init(arg) do
    :ets.new(:stories, [:set, :public, :named_table])

    {:ok, arg}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, get(key), state}
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    {:reply, put(key, value), state}
  end

  defp get(key) do
    case :ets.lookup(:stories, "stories") do
      [] ->
        nil

      [{_key, value}] ->
        Map.get(value, key)
    end
  end

  defp put(key, value) do
    :ets.insert_new(:stories, {key, value})
  end
end
