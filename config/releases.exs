import Config

config :freedom, FreedomWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT", "4000"))],
  url: [host: System.fetch_env!("DOMAIN_NAME"), scheme: "https", port: 443],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  live_view: [
    signing_salt: System.fetch_env!("LIVE_VIEW_SIGNING_SALT")
  ]

config :libcluster,
  topologies: [
    freedom: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: System.get_env("SERVICE_NAME", "freedom"),
        application_name: "freedom",
        polling_interval: 5_000
      ]
    ]
  ]

config :freedom, FreedomWeb.PowMailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.fetch_env!("MAILGUN_API_KEY"),
  domain: System.fetch_env!("MAILGUN_DOMAIN")

config :freedom, Freedom.Repo,
  username: System.fetch_env!("PG_USERNAME"),
  password: System.fetch_env!("PG_PASSWORD"),
  database: System.fetch_env!("PG_DB"),
  hostname: System.fetch_env!("PG_HOSTNAME")

config :freedom, :releases,
  cookie: System.fetch_env!("COOKIE"),
  pod_ip: System.fetch_env!("POD_IP")
