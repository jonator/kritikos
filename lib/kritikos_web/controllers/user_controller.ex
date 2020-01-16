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

      {:error, reasons} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> put_status(:forbidden)
        |> render("error.json", message: reasons)
    end
  end
end
