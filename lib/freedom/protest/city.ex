defmodule Freedom.Protest.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    field :province, :string
    field :timezone, :string

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :timezone, :province])
    |> validate_required([:name, :timezone, :province])
  end
end
