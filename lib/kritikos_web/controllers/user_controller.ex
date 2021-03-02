defmodule KritikosWeb.UserController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Auth
  require Logger

  plug KritikosWeb.Plug.EnsureAuthenticated,
       [store: :token] when action in [:update_password, :verify_email]

  def create(conn, %{"user" => user_params}, nil) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        try do
          KritikosWeb.Email.welcome(user.email, Auth.sign_user_token(user.id, "email_verify"))
          |> KritikosWeb.Mailer.deliver_now!()
        rescue
          e in Bamboo.ApiError ->
            Logger.error(e)

          _ ->
            Logger.error("Mailer failure")
        end

        conn
        |> put_session(:user, user)
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
      |> render("show.json", user: user)
    else
      {:error, reasons} ->
        user_error_resp(conn, reasons)
    end
  end

  def verify_email(conn, _params, user) do
    token = Auth.sign_user_token(user.id, "email_verify")

    send_status =
      try do
        KritikosWeb.Email.verify_email(user.email, token)
        |> KritikosWeb.Mailer.deliver_now!()

        true
      rescue
        _ -> false
      end

    conn
    |> render("verification_email_sent.json", sent: send_status)
  end

  defp user_error_resp(conn, reasons),
    do:
      conn
      |> put_view(KritikosWeb.ErrorView)
      |> render("error.json", message: reasons)
end
