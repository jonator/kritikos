defmodule KritikosWeb.SessionController do
  use KritikosWeb, :controller

  alias Kritikos.Auth

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Auth.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, jwt, _full_claims} = Auth.Guardian.encode_and_sign(user, %{}, token_type: :token)

    conn
    |> put_status(:created)
    |> render("login.json", jwt: jwt, user: user)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json", message: error)
  end
end
