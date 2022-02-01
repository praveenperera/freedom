import Config

config :freedom,
  ecto_repos: [Freedom.Repo]

config :freedom, FreedomWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c2IBEdf4jM0ebvy0i9H+AxxV9lkH1P4hQtiVLmWE2Ozl678hHQb+3XYGq//3sU6S",
  render_errors: [view: FreedomWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Freedom.PubSub,
  live_view: [
    signing_salt: "ZGnTqFRaNVjW+8sJvyYBgMl8X5sltZ9+mRRgSuEQiwe/GXuBZ/comMIllU/2yjMQ"
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :freedom, :pow,
  user: Freedom.Accounts.User,
  users_context: Freedom.Accounts,
  repo: Freedom.Repo,
  web_module: FreedomWeb,
  extensions: [PowResetPassword],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: FreedomWeb.PowMailer,
  web_mailer_module: FreedomWeb

import_config "#{Mix.env()}.exs"
