import Config

# Configure your database
config :freedom, Freedom.Repo,
  username: "postgres",
  password: "postgres",
  database: "freedom_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can efreedomle the server option below.
config :freedom, FreedomWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
