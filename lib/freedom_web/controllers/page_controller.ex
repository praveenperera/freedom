defmodule FreedomWeb.PageController do
  use FreedomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
