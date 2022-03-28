defmodule Ashurbanipal.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, _json}, state) do
    {:reply, {:text, :test}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
