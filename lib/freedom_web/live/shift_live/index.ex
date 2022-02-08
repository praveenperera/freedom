defmodule FreedomWeb.ShiftLive.Index do
  use FreedomWeb, :live_view

  alias Freedom.Protest
  alias Freedom.Protest.Shift
  alias FreedomWeb.Credentials
  alias Phoenix.LiveView.JS
  alias FreedomWeb.Live.ShiftLive.Helpers

  @interval 12

  @impl true
  def mount(_params, session, socket) do
    slots =
      0..23
      |> Enum.chunk_every(@interval)
      |> Enum.reject(fn x -> x == [] end)
      |> Enum.with_index()
      |> Enum.map(fn {hours, index} ->
        start = List.first(hours)
        last = List.last(hours)

        {index, Time.new!(start, 0, 0), Time.new!(last, 59, 59)}
      end)
      |> Enum.reduce(
        [],
        fn {index, start, last}, list ->
          [{index, %{start: start, end: last}} | list]
        end
      )
      |> Enum.sort_by(fn {index, _} -> index end)

    send(self(), {:get_shifts, slots})

    socket =
      socket
      |> assign(
        booking_index: nil,
        user_shifts: [],
        day_selection: false,
        days: [],
        shifts: %{},
        max_shifts: 1,
        slots: slots,
        current_user: Credentials.get_user(socket, session)
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    path =
      url
      |> URI.parse()
      |> Map.get(:path, "/")

    socket =
      socket
      |> assign(current_path: path)
      |> load_city(params["city"])
      |> set_day(params["day"])
      |> set_days()
      |> load_user_shifts()
      |> load_total_shifts()
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    socket
    |> assign(:page_title, "Edit Shift")
    |> assign(:shift, Protest.get_shift!(id))
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, "New Shift")
    |> assign(:shift, %Shift{})
  end

  defp apply_action(socket, :index, params) do
    city = socket.assigns.city.name
    day = socket.assigns.day

    socket
    |> assign(:page_title, "Freedom - #{city} Slots for #{day}")
    |> assign(:shift, nil)
  end

  def load_city(socket, city) do
    assign(socket, :city, Protest.get_city_by_slug!(city))
  end

  def load_user_shifts(socket) do
    assigns = socket.assigns

    if assigns.current_user do
      user_shifts =
        Protest.get_shifts_for_user_and_day(assigns.current_user.id, assigns.city.id, assigns.day)

      socket
      |> assign(
        :user_shifts,
        user_shifts
      )
    else
      socket
    end
  end

  def load_total_shifts(socket) do
    socket
    |> assign(
      :total_shifts,
      Protest.total_shifts_for_day(socket.assigns.city.id, socket.assigns.day)
    )
  end

  def set_day(socket, nil) do
    day =
      socket.assigns[:city].timezone
      |> DateTime.now!(Tzdata.TimeZoneDatabase)
      |> DateTime.to_date()

    assign(socket, day: day)
  end

  def set_day(socket, day) do
    assign(socket, :day, Date.from_iso8601!(day))
  end

  def set_days(socket) do
    today =
      socket.assigns[:city].timezone
      |> DateTime.now!(Tzdata.TimeZoneDatabase)
      |> DateTime.to_date()

    days =
      0..30
      |> Enum.map(fn i -> Date.add(today, i) end)
      |> Enum.map(fn day -> {Helpers.format(day), Date.to_iso8601(day)} end)

    assign(socket, days: days)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shift = Protest.get_shift!(id)
    {:ok, _} = Protest.delete_shift(shift)

    {:noreply, socket}
  end

  @impl true
  def handle_event("activate-day-selection", _, socket) do
    {:noreply, assign(socket, day_selection: true)}
  end

  @impl true
  def handle_event("deactivate-day-selection", _, socket) do
    {:noreply, assign(socket, day_selection: false)}
  end

  def handle_event(
        "save-day-selection",
        %{"day-selection-form" => %{"day" => day}},
        socket
      ) do
    socket =
      socket
      |> push_redirect(
        to: Routes.shift_index_path(socket, :index, socket.assigns.city.slug, day: day)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("book", %{"index" => index}, socket) do
    socket =
      socket
      |> assign(:booking_index, String.to_integer(index))

    {:noreply, socket}
  end

  @impl true
  def handle_info({:get_shifts, slots}, socket) do
    city_id = socket.assigns.city.id
    day = socket.assigns.day
    liveview = self()

    Enum.each(slots, fn {index, %{start: start, end: last}} ->
      Task.start(fn ->
        shifts = Protest.get_shift_between(city_id, day, start, last)

        send(liveview, {:received_shifts, {index, shifts}})
      end)
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:received_shifts, {index, shifts}}, socket) do
    count = Enum.count(shifts)

    shifts =
      socket.assigns.shifts
      |> Map.put(index, shifts)

    socket =
      if count > socket.assigns.max_shifts do
        assign(socket, :max_shifts, count)
      else
        socket
      end
      |> assign(:shifts, shifts)

    {:noreply, socket}
  end
end
