defmodule Freedom.Protest.City do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %Freedom.Protest.City{}

  schema "cities" do
    field(:name, :string)
    field(:province, :string)
    field(:timezone, :string)
    field(:slug, :string)

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :timezone, :province, :slug])
    |> validate_required([:name, :timezone, :province, :slug])
  end
end
