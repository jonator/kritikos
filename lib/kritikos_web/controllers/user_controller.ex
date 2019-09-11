defmodule KritikosWeb.UserController do
  use KritikosWeb, :controller

  alias Kritikos.Auth

  def create(conn, %{"user" => user_params}, _user) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)

      {:error, changeset} ->
        render(conn, KritikosWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
