import Config

config :hook, :ntfy_url, System.get_env("NTFY_URL", "https://ntfy.sh")

config :hook, :ntfy_topic, System.get_env("NTFY_TOPIC", "topic")

config :hook, :ntfy_token, System.get_env("NTFY_TOKEN", "")
