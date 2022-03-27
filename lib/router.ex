defmodule Ashurbanipal.Router do
  @doc false
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

    stories = %{stories: GenServer.call(Ashurbanipal.Stories, {:get, pagination_value})}
    send_json_response(conn, stories)
  end

  get "/stories/:story_id" do
    stories = GenServer.call(Ashurbanipal.Stories, {:get, :all})
    story_id_from_path = Helpers.parse_story_id_from_path(conn.path_params)

    case Map.get(stories, story_id_from_path) do
      nil -> send_resp(conn, 404, "Story Not Found")
      story ->
        send_json_response(conn, story)
    end
  end

  match _ do
    send_resp(conn, 404, "404")
  end

  defp send_json_response(conn, response_data) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(response_data))
  end
end
