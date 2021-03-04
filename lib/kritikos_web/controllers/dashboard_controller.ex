defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.{Auth, Auth.User}
  alias Kritikos.Votes

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
      |> render_dashboard(updated_user,
        initial_message: %{error: false, message: "✅Email verified successfully!"}
      )
    else
      {:error, _reason} ->
        render_dashboard(
          conn,
          user,
          initial_message: %{
            error: true,
            message: "Failed to activate email! Contact support (support@kritikos.app)"
          }
        )
    end
  end

  def dashboard(conn, %{"subscription" => "pro"}, user) do
    updated_user = Auth.get_active_user(user.id)

    case Kritikos.Stripe.get_user_subscription_status(updated_user.stripe_customer_id) do
      "pro" ->
        render_dashboard(
          conn,
          updated_user,
          initial_message: %{
            error: false,
            message: "🎉Congratulations! You are now a pro subscriber"
          },
          subscription: "pro"
        )

      "free" ->
        render_dashboard(conn, updated_user)
    end
  end

  def dashboard(conn, %{"subscription" => "cancelled"}, user) do
    render_dashboard(conn, user,
      initial_message: %{error: false, message: "🛑Subscription checkout cancelled"}
    )
  end

  def dashboard(conn, _params, user) do
    render_dashboard(conn, user)
  end

  def user_view_votes(conn, %{"vote_ids" => vote_ids}, _user) do
    case Votes.update_vote_ids_viewed(vote_ids) do
      {_update_cnt, updated_ids} ->
        render(conn, "viewed_votes.json", ids: updated_ids)

      _ ->
        render(conn, "error.json", message: "problem updating viewed votes")
    end
  end

  defp render_dashboard(conn, %User{} = user, opts \\ []) do
    token = Auth.sign_user_token(user.id)

    user_record =
      Auth.get_user(user.id)
      |> Map.from_struct()
      |> Map.put(:is_admin, conn.assigns.is_admin?)
      |> Map.put(
        :subscription_status,
        Keyword.get(opts, :subscription) ||
          Kritikos.Stripe.get_user_subscription_status(user.stripe_customer_id)
      )

    user_sessions = Sessions.get_for_user(user.id, preload: [{:votes, :feedback}, :tags])

    conn
    |> put_session(:user, user)
    |> render("dashboard.html",
      socket_token: token,
      user_record: user_record,
      sessions: user_sessions,
      initial_message: Keyword.get(opts, :initial_message)
    )
  end

  def terms_of_service(conn, _params, _user) do
    render(conn, "terms_of_service.html")
  end

  def privacy_policy(conn, _params, _user) do
    render(conn, "privacy_policy.html")
  end
end
