defmodule Hook.Plugs.Endpoint do
  require Logger
  use Plug.Router

  plug(Plug.RequestId)
  plug(Hook.Plugs.IpLog)
  plug(Plug.Logger, log: :info)

  plug(:match)
  plug(:dispatch)

  get "/health" do
    send_resp(conn, 200, "healthy")
  end

  forward("/api", to: Hook.Plugs.ApiRouter)

  match _ do
    send_resp(conn, 404, "Not Found") |> halt()
  end
end
