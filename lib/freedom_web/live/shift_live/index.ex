defmodule FreedomWeb.ShiftLive.Index do
  use FreedomWeb, :live_view

  alias Freedom.Protest
  alias Freedom.Protest.Shift
  alias FreedomWeb.Credentials

  @interval 3

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
      |> set_date(params["date"])
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
    socket
    |> assign(:page_title, "Listing Shifts")
    |> assign(:shift, nil)
  end

  def load_city(socket, city) do
    assign(socket, :city, Protest.get_city_by_slug!(city))
  end

  def load_total_shifts(socket) do
    socket
    |> assign(
      :total_shifts,
      Protest.total_shifts_for_day(socket.assigns.city.id, socket.assigns.date)
    )
  end

  def set_date(socket, nil) do
    date =
      socket.assigns[:city].timezone
      |> DateTime.now!(Tzdata.TimeZoneDatabase)
      |> DateTime.to_date()

    assign(socket, :date, date)
  end

  def set_date(socket, date) do
    assign(socket, :date, DateTime.parse(date))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shift = Protest.get_shift!(id)
    {:ok, _} = Protest.delete_shift(shift)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:get_shifts, slots}, socket) do
    city_id = socket.assigns.city.id
    date = socket.assigns.date
    liveview = self()

    Enum.each(slots, fn {index, %{start: start, end: last}} ->
      Task.start(fn ->
        shifts = Protest.get_shift_between(city_id, date, start, last)

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

  def format(%Time{} = time), do: Calendar.strftime(time, "%I:%M%p")
end
