defmodule FreedomWeb.ShiftLive.FormComponent do
  use FreedomWeb, :live_component

  alias Freedom.Protest

  @impl true
  def update(%{shift: shift} = assigns, socket) do
    changeset = Protest.change_shift(shift)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"shift" => shift_params}, socket) do
    changeset =
      socket.assigns.shift
      |> Protest.change_shift(shift_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"shift" => shift_params}, socket) do
    save_shift(socket, socket.assigns.action, shift_params)
  end

  defp save_shift(socket, :edit, shift_params) do
    case Protest.update_shift(socket.assigns.shift, shift_params) do
      {:ok, _shift} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shift updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_shift(socket, :new, shift_params) do
    case Protest.create_shift(shift_params) do
      {:ok, _shift} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shift created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
