defmodule FreedomWeb.ShiftLive.Index do
  use FreedomWeb, :live_view

  alias Freedom.Protest
  alias Freedom.Protest.Shift

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :shifts, list_shifts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shift")
    |> assign(:shift, Protest.get_shift!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shift")
    |> assign(:shift, %Shift{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shifts")
    |> assign(:shift, nil)
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
end
