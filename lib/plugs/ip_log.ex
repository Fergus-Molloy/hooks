defmodule Hook.Plugs.IpLog do
  require Logger
  @behaviour Plug

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    Logger.metadata(client_ip: get_ip(conn))
    conn
  end

  defp get_ip(conn) do
    case List.keyfind(conn.req_headers, "x-forwarded-for", 0) do
      nil ->
        conn.remote_ip |> ip_to_string()

      {_, forwarded_ip} ->
        forwarded_ip
    end
  end

  defp ip_to_string(ip), do: ip |> IO.inspect(label: "using ip") |> :inet.ntoa() |> to_string()
end
