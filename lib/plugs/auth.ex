defmodule Hook.Plugs.Auth do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(%{req_headers: headers} = conn, _opts) do
    token = System.get_env("AUTH_TOKEN")

    if token == nil do
      conn
    else
      {_, auth_value} = List.keyfind(headers, "authorization", 0, {"", ""})

      if !String.ends_with?(auth_value, token) do
        conn |> send_resp(401, "Unauthorized") |> halt()
      else
        conn
      end
    end
  end
end
