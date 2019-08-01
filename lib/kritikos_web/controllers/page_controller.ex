defmodule KritikosWeb.PageController do
  use KritikosWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
