defmodule Hook.Plugs.Slskd do
  require Logger
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

    Logger.debug("Sending request to ntfy", req: req)

    req = if token != "", do: put_header(req, "Authorization", "Bearer #{token}")

    {:ok, %{status: status} = resp} = Req.request(req)

    if status < 300 && status >= 200 do
      conn
      |> send_resp(200, "ok")
    else
      Logger.warning("Got non 200 response from ntfy", ntfy_resp: resp)

      conn
      |> send_resp(500, "Failed to send notification to ntfy, status: #{status}")
    end
  end
end
