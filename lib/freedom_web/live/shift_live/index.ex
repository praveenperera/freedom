defmodule FreedomWeb.ShiftLive.Index do
  use FreedomWeb, :live_view

  alias Freedom.Protest
  alias Freedom.Protest.Shift

  @interval 3

  @impl true
  def mount(_params, _session, socket) do
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

    socket =
      socket
      |> assign(:shifts, list_shifts())
      |> assign(:slots, slots)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> load_city(params["city"])
      |> set_date(params["date"])
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
    assign(socket, :city, Freedom.Protest.get_city_by_slug!(city))
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

    {:noreply, assign(socket, :shifts, list_shifts())}
  end

  defp list_shifts do
    Protest.list_shifts()
  end

  def format(%Time{} = time), do: Calendar.strftime(time, "%I:%M%p")
end
