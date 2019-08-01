defmodule KritikosWeb.UserController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  alias Kritikos.Auth

  plug Guardian.Plug.EnsureAuthenticated when action in [:current_user, :update]

  def create(conn, %{"user" => user_params}, _user) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
            user
            |> Auth.Guardian.encode_and_sign(%{}, token_type: :token)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)
      {:error, changeset} ->
        render(conn, KritikosWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
