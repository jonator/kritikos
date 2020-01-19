defmodule KritikosWeb.SessionsController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :token

  def start_session(conn, params, user) do
    name = params["name"]
    keyword = params["keyword"]
    tags = params["tags"]
    profile = Kritikos.Auth.get_assoc_profile(user)

    case Sessions.start(profile.id, name, keyword, tags) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, changeset} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: changeset})
    end
  end

  def end_session(conn, %{"keyword" => keyword}, _user) do
    case Sessions.stop(keyword) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, %Ecto.Changeset{} = cs} ->
        conn
        |> put_status(:forbidden)
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: cs})

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end
end
