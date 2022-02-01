defmodule Freedom.Accounts.User do
  use Ecto.Schema
  import EctoEnum
  alias Freedom.Accounts.User

  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2}

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword]

  defenum(Role, ["member", "admin"])
  defenum(Status, ["active", "disabled", "deleted"])

  schema "users" do
    field :role, User.Role, default: :member
    field :status, User.Status, default: :active

    pow_user_fields()
    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end
end
