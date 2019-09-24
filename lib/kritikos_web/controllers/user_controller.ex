defmodule KritikosWeb.UserController do
  use KritikosWeb, :controller

  alias Kritikos.Auth

  def create(conn, %{"user" => user_params}) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user, user)
        |> put_status(:ok)
        |> render("login.json", user: user)

      {:error, changeset} ->
        conn
        |> put_view(KritikosWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
