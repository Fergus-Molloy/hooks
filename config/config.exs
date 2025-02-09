import Config

config :logger, :console, metadata: [:request_id]

config :hook, :auth_token, System.get_env("AUTH_TOKEN", "")
