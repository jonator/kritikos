defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.{Auth, Auth.User}

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :cookie
  plug KritikosWeb.Plug.IsAdmin, email: "jonathanator0@gmail.com"

  def dashboard(conn, %{"verifyEmail" => _}, %User{is_email_active: true} = user) do
    render_dashboard(conn, user)
  end

  def dashboard(conn, %{"verifyEmail" => token}, %User{id: user_id} = user) do
    with {:ok, ^user_id} <-
           Auth.verify_token(token, "email_verify"),
         {:ok, updated_user} <- Auth.update_user(user, %{is_email_active: true}) do
      conn
      |> put_session(:user, updated_user)
      |> render_dashboard(updated_user, %{error: false, message: "✅Email confirmed"})
    else
      {:error, _reason} ->
        render_dashboard(
          conn,
          user,
          %{
            error: true,
            message: "Failed to activate email! Contact support (support@kritikos.app)"
          }
        )
    end
  end

  def dashboard(conn, _params, user) do
    render_dashboard(conn, user)
  end

  defp render_dashboard(conn, user, initial_message \\ nil) do
    token = Auth.sign_user_token(user.id)

    user =
      Auth.get_user(user.id) |> Map.from_struct() |> Map.put(:is_admin, conn.assigns.is_admin?)

    user_sessions = Sessions.get_for_user(user.id, preload: [{:votes, :feedback}, :tags])

    render(conn, "dashboard.html",
      socket_token: token,
      user_record: user,
      sessions: user_sessions,
      initial_message: initial_message
    )
  end
end
