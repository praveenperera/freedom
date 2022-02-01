import Config

config :freedom, Freedom.Repo,
  username: "postgres",
  password: "postgres",
  database: "freedom_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :freedom, FreedomWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

#
config :freedom, FreedomWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/freedom_web/{live,views}/.*(ex)$",
      ~r"lib/freedom_web/templates/.*(eex)$"
    ]
  ]

config :freedom, FreedomWeb.PowMailer, adapter: Bamboo.LocalAdapter
config :freedom, Freedom.Mailing.Mailer, adapter: Bamboo.LocalAdapter

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.13.10",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

import_config "dev.secret.exs"
