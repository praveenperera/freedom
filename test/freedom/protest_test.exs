defmodule Freedom.ProtestTest do
  use Freedom.DataCase

  alias Freedom.Protest

  describe "shifts" do
    alias Freedom.Protest.Shift

    import Freedom.ProtestFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_shifts/0 returns all shifts" do
      shift = shift_fixture()
      assert Protest.list_shifts() == [shift]
    end

    test "get_shift!/1 returns the shift with given id" do
      shift = shift_fixture()
      assert Protest.get_shift!(shift.id) == shift
    end

    test "create_shift/1 with valid data creates a shift" do
      valid_attrs = %{end: ~N[2022-01-31 15:53:00], start: ~N[2022-01-31 15:53:00]}

      assert {:ok, %Shift{} = shift} = Protest.create_shift(valid_attrs)
      assert shift.end == ~N[2022-01-31 15:53:00]
      assert shift.start == ~N[2022-01-31 15:53:00]
    end

    test "create_shift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Protest.create_shift(@invalid_attrs)
    end

    test "update_shift/2 with valid data updates the shift" do
      shift = shift_fixture()
      update_attrs = %{end: ~N[2022-02-01 15:53:00], start: ~N[2022-02-01 15:53:00]}

      assert {:ok, %Shift{} = shift} = Protest.update_shift(shift, update_attrs)
      assert shift.end == ~N[2022-02-01 15:53:00]
      assert shift.start == ~N[2022-02-01 15:53:00]
    end

    test "update_shift/2 with invalid data returns error changeset" do
      shift = shift_fixture()
      assert {:error, %Ecto.Changeset{}} = Protest.update_shift(shift, @invalid_attrs)
      assert shift == Protest.get_shift!(shift.id)
    end

    test "delete_shift/1 deletes the shift" do
      shift = shift_fixture()
      assert {:ok, %Shift{}} = Protest.delete_shift(shift)
      assert_raise Ecto.NoResultsError, fn -> Protest.get_shift!(shift.id) end
    end

    test "change_shift/1 returns a shift changeset" do
      shift = shift_fixture()
      assert %Ecto.Changeset{} = Protest.change_shift(shift)
    end
  end

  describe "cities" do
    alias Freedom.Protest.City

    import Freedom.ProtestFixtures

    @invalid_attrs %{name: nil, province: nil, timezone: nil}

    test "list_cities/0 returns all cities" do
      city = city_fixture()
      assert Protest.list_cities() == [city]
    end

    test "get_city!/1 returns the city with given id" do
      city = city_fixture()
      assert Protest.get_city!(city.id) == city
    end

    test "create_city/1 with valid data creates a city" do
      valid_attrs = %{name: "some name", province: "some province", timezone: "some timezone"}

      assert {:ok, %City{} = city} = Protest.create_city(valid_attrs)
      assert city.name == "some name"
      assert city.province == "some province"
      assert city.timezone == "some timezone"
    end

    test "create_city/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Protest.create_city(@invalid_attrs)
    end

    test "update_city/2 with valid data updates the city" do
      city = city_fixture()
      update_attrs = %{name: "some updated name", province: "some updated province", timezone: "some updated timezone"}

      assert {:ok, %City{} = city} = Protest.update_city(city, update_attrs)
      assert city.name == "some updated name"
      assert city.province == "some updated province"
      assert city.timezone == "some updated timezone"
    end

    test "update_city/2 with invalid data returns error changeset" do
      city = city_fixture()
      assert {:error, %Ecto.Changeset{}} = Protest.update_city(city, @invalid_attrs)
      assert city == Protest.get_city!(city.id)
    end

    test "delete_city/1 deletes the city" do
      city = city_fixture()
      assert {:ok, %City{}} = Protest.delete_city(city)
      assert_raise Ecto.NoResultsError, fn -> Protest.get_city!(city.id) end
    end

    test "change_city/1 returns a city changeset" do
      city = city_fixture()
      assert %Ecto.Changeset{} = Protest.change_city(city)
    end
  end
end
