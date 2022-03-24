defmodule Ashurbanipal.Router do
  use Plug.Router

  plug Plug.Static,
    at: "/",
    from: :ashurbanipal
  plug :match
  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "hello")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
