defmodule Freedom.Repo do
  use Ecto.Repo,
    otp_app: :freedom,
    adapter: Ecto.Adapters.Postgres

  def db_ready?, do: Freedom.Repo.checkout(fn -> :ok end)
end
