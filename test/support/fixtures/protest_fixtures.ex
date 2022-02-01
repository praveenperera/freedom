defmodule Freedom.ProtestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Freedom.Protest` context.
  """

  @doc """
  Generate a shift.
  """
  def shift_fixture(attrs \\ %{}) do
    {:ok, shift} =
      attrs
      |> Enum.into(%{
        end: ~N[2022-01-31 15:53:00],
        start: ~N[2022-01-31 15:53:00]
      })
      |> Freedom.Protest.create_shift()

    shift
  end

  @doc """
  Generate a city.
  """
  def city_fixture(attrs \\ %{}) do
    {:ok, city} =
      attrs
      |> Enum.into(%{
        name: "some name",
        province: "some province",
        timezone: "some timezone"
      })
      |> Freedom.Protest.create_city()

    city
  end
end
