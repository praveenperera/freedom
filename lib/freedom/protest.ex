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

  def get_shifts_for_user_and_day(user_id, city_id, %Date{} = day) do
    Shift
    |> Shift.shifts_for_day(day)
    |> Shift.in_city(city_id)
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def total_shifts_for_day(city_id, %Date{} = day) do
    Shift
    |> Shift.shifts_for_day(day)
    |> Shift.in_city(city_id)
    |> select([s], count(s.id))
    |> Repo.one()
  end

  def get_shift_between(city_id, %Date{} = date, start_time, end_time) do
    start_datetime = DateTime.new!(date, start_time)
    end_datetime = DateTime.new!(date, end_time)

    Shift
    |> Shift.in_city(city_id)
    |> Shift.shifts_between(start_datetime, end_datetime)
    |> Repo.all()
  end

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

  def change_shift(%Shift{} = shift, attrs \\ %{}) do
    Shift.changeset(shift, attrs)
  end

  def delete_shift(%Shift{} = shift) do
    Repo.delete(shift)
  end

  def get_city_by_slug!(slug), do: Repo.get_by!(City, slug: slug)

  def slot_already_booked?(day, slot, shifts) do
    slot_start_datetime = NaiveDateTime.new!(day, slot.start)
    slot_end_datetime = NaiveDateTime.new!(day, slot.end)

    Enum.find(shifts, fn shift ->
      inclusive_between(shift.start, slot_start_datetime, shift.end, slot_end_datetime)
    end) != nil
  end

  defp inclusive_between(search_start, interval_start, search_end, interval_end) do
    (Calendar.NaiveDateTime.after?(search_start, interval_start) &&
       Calendar.NaiveDateTime.before?(search_end, interval_end)) ||
      (search_start == interval_start && search_end == interval_end)
  end
end
