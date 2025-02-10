import Config

config :hook, :ntfy_url, System.get_env("NTFY_URL", "https://ntfy.sh")

config :hook, :ntfy_topic, System.get_env("NTFY_TOPIC", "topic")

config :hook, :ntfy_token, System.get_env("NTFY_TOKEN", "")

log_level =
  case(System.get_env("LOG_LEVEL", "info")) do
    "debug" -> :debug
    "notice" -> :notice
    "warn" -> :warning
    "error" -> :error
    "crit" -> :critical
    "alert" -> :alert
    _ -> :info
  end

config :logger, level: log_level
