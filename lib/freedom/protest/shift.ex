defmodule Freedom.Protest.Shift do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum
  import Ecto.Query
  alias Freedom.Protest.Shift

  defenum(Vehicle, ["4_wheeler", "by_foot", "18_wheeler"])

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
  def in_city(query \\ Shift, city_id) do
    query
    |> where(city_id: ^city_id)
  end

  def shifts_for_day(query \\ Shift, %Date{} = day) do
    start_datetime = DateTime.new!(day, Time.new!(0, 0, 0))
    end_datetime = DateTime.new!(day, Time.new!(23, 59, 59))

    query
    |> shifts_between(start_datetime, end_datetime)
  end

  def shifts_between(query \\ Shift, start_datetime, end_datetime) do
    query
    |> where([s], s.start >= ^start_datetime)
    |> where([s], s.end <= ^end_datetime)
  end

  def vehicles_select() do
    Vehicle.__valid_values__()
    |> Enum.filter(&is_binary/1)
    |> Enum.map(fn name -> {map_to_human_vehicle_name(name), name} end)
  end

  defp map_to_human_vehicle_name("18_wheeler"), do: "18 Wheeler"
  defp map_to_human_vehicle_name("4_wheeler"), do: "4 Wheeler (Truck, Van, Car etc...)"
  defp map_to_human_vehicle_name("by_foot"), do: "On Foot"
end
