defmodule FreedomWeb.PageController do
  use FreedomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def edmonton(conn, _params), do: redirect(conn, to: "/shifts/edmonton")
end
