defmodule Ashurbanipal.Router do
  use Plug.Router

  plug Plug.Static, at: "/", from: :ashurbanipal
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug :match

  plug :dispatch

  alias Ashurbanipal.Helpers

  get "/stories" do
    pagination_value =
      Helpers.parse_pagination_query(conn.query_params)
      |> Helpers.parse_pagination_value()

    stories = %{stories: GenServer.call(Ashurbanipal.Stories, {:get, "stories", pagination_value})}

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(stories))
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
