defmodule FreedomWeb.Plug.EnsureStatus do
  @moduledoc """
  This plug ensures that a user has a particular status.

  ## Example

      plug FreedomWeb.EnsureStatus, [:active, :invited]

      plug FreedomWeb.EnsureStatus, :invited

      plug FreedomWeb.EnsureStatus, ~w(active invited)a
  """
  import Plug.Conn, only: [halt: 1]

  alias FreedomWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller
  alias Plug.Conn
  alias Pow.Plug

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom() | binary() | [atom()] | [binary()]) :: Conn.t()
  def call(conn, statuses) do
    conn
    |> Plug.current_user()
    |> has_status?(statuses)
    |> maybe_halt(conn)
  end

  defp has_status?(nil, _statuses), do: false

  defp has_status?(user, statuses) when is_list(statuses),
    do: Enum.any?(statuses, &has_status?(user, &1))

  defp has_status?(%{status: status}, status), do: true
  defp has_status?(_user, _status), do: false

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
end
