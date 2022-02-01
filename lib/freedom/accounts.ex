defmodule Freedom.Accounts do
  use Pow.Ecto.Context,
    repo: Freedom.Repo,
    user: Freedom.Accounts.User
end
