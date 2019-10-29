defmodule KritikosWeb.ExportController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Exporter
  alias Kritikos.Sessions.LiveSession

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"
  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def export_options(conn, _params, _user) do
    render(conn, "export.html")
  end

  def fullscreen(conn, _params, user) do
    case LiveSession.take_state(user.id, [:keyword]) do
      %{keyword: keyword} ->
        render(conn, "fullscreen.html", keyword: keyword)

      _ ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.html", reason: "Problem generating fullscreen export")
    end
  end

  def qr_code_image(conn, %{"image" => keyword_png}, _user) do
    with keyword <- String.replace_trailing(keyword_png, ".png", ""),
         {:ok, exporter} <- LiveSession.get_exporter_pid(keyword),
         {:ok, png_binary} <- Exporter.qr_code_png_binary(exporter) do
      conn
      |> send_download({:binary, png_binary}, filename: keyword_png)
    else
      {:error, reason} when is_binary(reason) ->
        conn
        |> put_status(:not_found)
        |> text(reason)

      _ ->
        conn
        |> put_status(:not_found)
        |> text("Not found")
    end
  end
end
