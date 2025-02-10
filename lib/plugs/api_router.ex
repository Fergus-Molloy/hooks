defmodule Hook.Plugs.ApiRouter do
  require Logger
  use Plug.Router

  plug(:match)

  plug(Hook.Plugs.Auth)

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(:dispatch)

  post("slskd", to: Hook.Plugs.Slskd)

  match _ do
    send_resp(conn, 404, "Not Found") |> halt()
  end
end
