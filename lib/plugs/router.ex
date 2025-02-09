defmodule Hook.Plugs.Router do
  use Plug.Router

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(Hook.Plugs.Auth)

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/health" do
    send_resp(conn, 200, "healthy")
  end

  match("/api/slskd", via: :post, to: Hook.Plugs.Slskd)

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
