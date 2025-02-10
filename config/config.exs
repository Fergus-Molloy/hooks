import Config

config :logger, :console, metadata: [:request_id, :client_ip]

config :hook, :auth_token, System.get_env("AUTH_TOKEN", "")
