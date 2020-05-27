defmodule KritikosWeb.UserController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Auth

  plug KritikosWeb.Plug.EnsureAuthenticated, [store: :token] when action in [:update_password]

  def create(conn, %{"user" => user_params}, nil) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        KritikosWeb.Email.welcome(user.email, Auth.sign_user_token(user.id, "email_verify"))
        |> KritikosWeb.Mailer.deliver_now()

        conn
        |> put_session(:user, user)
        |> put_status(:ok)
        |> render("login.json", user: user)

      {:error, reasons} ->
        user_error_resp(conn, reasons)
    end
  end

  def update_password(conn, %{"attrs" => update_attrs}, user) do
    with {:ok, user} <- Auth.authenticate_user(user.email, update_attrs["currentPassword"]),
         update_user_attrs = %{
           "password" => update_attrs["newPassword"],
           "password_confirmation" => update_attrs["confirmNewPassword"]
         },
         {:ok, user} <-
           Auth.update_user(user, update_user_attrs) do
      conn
      |> put_session(:user, user)
      |> put_status(:ok)
      |> render("show.json")
    else
      {:error, reasons} ->
        user_error_resp(conn, reasons)
    end
  end

  defp user_error_resp(conn, reasons),
    do:
      conn
      |> put_view(KritikosWeb.ErrorView)
      |> put_status(:forbidden)
      |> render("error.json", message: reasons)
end
