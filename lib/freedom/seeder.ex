defmodule Freedom.Seeder do
  alias Freedom.Protest.City
  alias Freedom.Repo

  def run() do
    cities = [
      get_or_update(%City{
        name: "Edmonton",
        province: "Alberta",
        timezone: "America/Edmonton",
        slug: "edmonton"
      }),
      get_or_update(%City{
        name: "Coutts",
        province: "Alberta",
        timezone: "America/Edmonton",
        slug: "coutts"
      })
    ]

    if System.get_env("SEED_DUMMY_DATA") do
      IO.puts("SEED_DUMMY_DATA set, seeding data")

      day = DateTime.utc_now() |> DateTime.to_date()

      for city <- cities do
        seed_random_shifts_for_day(day, city)
      end
    end
  end

  def get_or_update(%City{} = city) do
    city_params = city |> Map.from_struct() |> Map.drop([:__meta__])

    case Repo.get_by(City, slug: city.slug) do
      nil ->
        Repo.insert!(city)

      old ->
        old
        |> City.changeset(city_params)
        |> Repo.update!()
    end
  end

  def seed_random_shifts_for_day(%Date{} = day, %City{} = city) do
    for _ <- 0..500 do
      hour = Enum.random(0..23)
      start_time = Time.new!(hour, 0, 0)

      end_time =
        (hour + Enum.random(0..7))
        |> min(23)
        |> Time.new!(59, 59)

      %Freedom.Protest.ShiftForDay{
        city_id: city.id,
        user_id: 1,
        day: day,
        start_time: start_time,
        end_time: end_time,
        vehicle: Enum.random(Freedom.Protest.Shift.Vehicle.__valid_values__())
      }
      |> Freedom.Protest.book_shift_for_day()
    end
  end
end
