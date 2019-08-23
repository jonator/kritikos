defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Sessions.LiveSession

  def live_session(conn, %{"keyword" => keyword}) do
    load_template_with_existing_session(conn, "live_session.html", keyword)
  end

  def kiosk_live_session(conn, %{"keyword" => keyword}) do
    load_template_with_existing_session(conn, "kiosk_live_session.html", keyword)
  end

  defp load_template_with_existing_session(conn, template, keyword) do
    if LiveSession.exists?(keyword) || Mix.env() == :dev do
      render(conn, template, keyword: keyword)
    else
      conn
      |> put_view(KritikosWeb.ErrorView)
      |> render("error.html", reason: "Feedback session #{keyword} doesn't exist!")
    end
  end
end
