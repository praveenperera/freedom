defmodule Freedom.Protest do
  @moduledoc """
  The Protest context.
  """

  import Ecto.Query, warn: false
  alias Freedom.Repo

  alias Freedom.Protest.Shift
  alias Freedom.Protest.City

  use TypedStruct

  typedstruct module: ShiftForDay, enforce: true do
    field(:day, Date.t())
    field(:start_time, Time.t())
    field(:end_time, Time.t())
    field(:vehicle, String.t())

    field(:city_id, pos_integer())
    field(:user_id, pos_integer())
  end

  def list_shifts do
    Repo.all(Shift)
  end

  def list_cities do
    Repo.all(City)
  end

  def get_shift!(id), do: Repo.get!(Shift, id)

  def book_shift_for_day(%ShiftForDay{} = params) do
    params
    |> Map.from_struct()
    |> Map.take([:vehicle, :user_id, :city_id])
    |> Map.merge(%{
      start: DateTime.new!(params.day, params.start_time),
      end: DateTime.new!(params.day, params.end_time)
    })
    |> create_shift()
  end

  def create_shift(attrs \\ %{}) do
    %Shift{}
    |> Shift.changeset(attrs)
    |> Repo.insert()
  end

  def delete_shift(%Shift{} = shift) do
    Repo.delete(shift)
  end

  def get_city_by_slug!(slug), do: Repo.get_by!(City, slug: slug)
end
