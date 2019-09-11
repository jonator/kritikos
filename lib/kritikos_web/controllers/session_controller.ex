defmodule KritikosWeb.SessionController do
  use KritikosWeb, :controller

  alias Kritikos.Auth

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("show.json", message: user)

      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: msg)
    end
  end
end
