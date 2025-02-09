defmodule Hook.Plugs.Slskd do
  import Plug.Conn
  import Req.Request

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    body = conn.body_params

    size = Map.get(body, "transfer") |> Map.get("size")
    filename = Map.get(body, "localFilename") |> String.split("/") |> List.last()

    base_url = Application.get_env(:hook, :ntfy_url)
    topic = Application.get_env(:hook, :ntfy_topic)
    token = Application.get_env(:hook, :ntfy_token)

    req =
      Req.new(
        url: "#{base_url}/#{topic}",
        method: :post,
        body: "slskd downloaded #{size} bytes"
      )

    req =
      put_headers(req, [
        {"Tags", "white_check_mark"},
        {"Priority", "low"},
        {"content-type", "text/plain"},
        {"Title", "Downloaded: #{filename}"}
      ])

    req = if token <> "", do: put_header(req, "Authorization", "Bearer #{token}")

    IO.inspect(req, label: "ntfy req")

    {:ok, %{status: status}} = Req.request(req)

    IO.inspect(status, label: "ntfy response status")

    conn
    |> send_resp(200, "ok")
  end
end
