defmodule Freedom.Protest.Shift do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum
  import Ecto.Query
  alias Freedom.Protest.Shift

  defenum(Vehicle, ["18_wheeler", "4_wheeler", "by_foot"])

  schema "shifts" do
    field(:end, :naive_datetime)
    field(:start, :naive_datetime)
    field(:vehicle, Vehicle)

    belongs_to(:user, Freedom.Accounts.User)
    belongs_to(:city, Freedom.Protest.City)

    timestamps()
  end

  @doc false
  def changeset(shift, attrs) do
    shift
    |> cast(attrs, [:start, :end, :vehicle, :user_id, :city_id])
    |> validate_required([:start, :end, :vehicle, :user_id, :city_id])
  end

  ### QUERIES
  def shifts_between(query \\ Shift, start_datetime, end_datetime) do
    query
    |> where([s], s.start >= ^start_datetime)
    |> where([s], s.end <= ^end_datetime)
  end
end
