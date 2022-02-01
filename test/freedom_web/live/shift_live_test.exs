defmodule FreedomWeb.ShiftLiveTest do
  use FreedomWeb.ConnCase

  import Phoenix.LiveViewTest
  import Freedom.ProtestFixtures

  @create_attrs %{end: %{day: 31, hour: 17, minute: 24, month: 1, year: 2022}, start: %{day: 31, hour: 17, minute: 24, month: 1, year: 2022}, vehicle: "some vehicle"}
  @update_attrs %{end: %{day: 1, hour: 17, minute: 24, month: 2, year: 2022}, start: %{day: 1, hour: 17, minute: 24, month: 2, year: 2022}, vehicle: "some updated vehicle"}
  @invalid_attrs %{end: %{day: 30, hour: 17, minute: 24, month: 2, year: 2022}, start: %{day: 30, hour: 17, minute: 24, month: 2, year: 2022}, vehicle: nil}

  defp create_shift(_) do
    shift = shift_fixture()
    %{shift: shift}
  end

  describe "Index" do
    setup [:create_shift]

    test "lists all shifts", %{conn: conn, shift: shift} do
      {:ok, _index_live, html} = live(conn, Routes.shift_index_path(conn, :index))

      assert html =~ "Listing Shifts"
      assert html =~ shift.vehicle
    end

    test "saves new shift", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.shift_index_path(conn, :index))

      assert index_live |> element("a", "New Shift") |> render_click() =~
               "New Shift"

      assert_patch(index_live, Routes.shift_index_path(conn, :new))

      assert index_live
             |> form("#shift-form", shift: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#shift-form", shift: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shift_index_path(conn, :index))

      assert html =~ "Shift created successfully"
      assert html =~ "some vehicle"
    end

    test "updates shift in listing", %{conn: conn, shift: shift} do
      {:ok, index_live, _html} = live(conn, Routes.shift_index_path(conn, :index))

      assert index_live |> element("#shift-#{shift.id} a", "Edit") |> render_click() =~
               "Edit Shift"

      assert_patch(index_live, Routes.shift_index_path(conn, :edit, shift))

      assert index_live
             |> form("#shift-form", shift: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#shift-form", shift: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shift_index_path(conn, :index))

      assert html =~ "Shift updated successfully"
      assert html =~ "some updated vehicle"
    end

    test "deletes shift in listing", %{conn: conn, shift: shift} do
      {:ok, index_live, _html} = live(conn, Routes.shift_index_path(conn, :index))

      assert index_live |> element("#shift-#{shift.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shift-#{shift.id}")
    end
  end

  describe "Show" do
    setup [:create_shift]

    test "displays shift", %{conn: conn, shift: shift} do
      {:ok, _show_live, html} = live(conn, Routes.shift_show_path(conn, :show, shift))

      assert html =~ "Show Shift"
      assert html =~ shift.vehicle
    end

    test "updates shift within modal", %{conn: conn, shift: shift} do
      {:ok, show_live, _html} = live(conn, Routes.shift_show_path(conn, :show, shift))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shift"

      assert_patch(show_live, Routes.shift_show_path(conn, :edit, shift))

      assert show_live
             |> form("#shift-form", shift: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#shift-form", shift: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shift_show_path(conn, :show, shift))

      assert html =~ "Shift updated successfully"
      assert html =~ "some updated vehicle"
    end
  end
end
