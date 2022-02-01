defmodule Freedom.Repo do
  use Ecto.Repo,
    otp_app: :freedom,
    adapter: Ecto.Adapters.Postgres
end
