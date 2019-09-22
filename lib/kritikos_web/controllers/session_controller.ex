defmodule KritikosWeb.SessionController do
  use KritikosWeb, :controller

  alias Kritikos.Auth

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user, user)
        |> put_status(:ok)
        |> render("login.json", user: user)

      {:error, msg} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> put_status(:unauthorized)
        |> render("error.json", message: msg)
    end
  end
end
