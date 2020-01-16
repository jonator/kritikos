defmodule KritikosWeb.SessionsController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :token

  def create(conn, params, user) do
    keyword = params["keyword"]
    tags = params["tags"]
    profile = Kritikos.Auth.get_assoc_profile(user)

    case Sessions.start(profile.id, keyword, tags) do
      {:ok, session} ->
        conn
        |> render("show.json", %{session: session})

      {:error, changeset} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> put_status(:internal_server_error)
        |> render("error.json", %{changeset: changeset})
    end
  end

  def drop(conn, %{"keyword" => keyword}, _user) do
    case Sessions.stop(keyword) do
      {:ok, session} ->
        conn |> render("show.json", %{session: session})

      {:error, %Ecto.Changeset{} = cs} ->
        conn
        |> put_status(:forbidden)
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{changeset: cs})

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", %{message: reason})
    end
  end
end
