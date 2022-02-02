defmodule FreedomWeb.ShiftLive.FormComponent do
  use FreedomWeb, :live_component
  alias Freedom.Protest
  alias FreedomWeb.Live.ShiftLive.Helpers

  @impl true
  def update(assigns, socket) do
    changeset = Protest.change_shift(%Protest.Shift{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"shift" => shift_params}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"shift" => shift_params}, socket) do
    save_shift(socket, shift_params)
  end

  defp save_shift(socket, shift_params) do
    assigns = socket.assigns

    params = %Freedom.Protest.ShiftForDay{
      city_id: assigns.city_id,
      user_id: assigns.user_id,
      day: assigns.day,
      start_time: assigns.slot.start,
      end_time: assigns.slot.end,
      vehicle: shift_params["vehicle"]
    }

    with false <- Protest.slot_already_booked?(assigns.day, assigns.slot, assigns.user_shifts),
         {:ok, _shift} <- Protest.book_shift_for_day(params) do
      {:noreply,
       socket
       |> put_flash(:info, "Shift created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      _ ->
        {:noreply, socket}
    end
  end
end
