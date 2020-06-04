defmodule KritikosWeb.StripeController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Auth.User

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :token
  plug :ensure_stripe_customer

  def create_checkout_session(conn, _params, %User{stripe_customer_id: customer_id}) do
    case Kritikos.Stripe.create_checkout_session(customer_id) do
      {:ok, checkout_session} ->
        conn
        |> render("stripe_object.json", stripe_object: checkout_session)

      {:error, reason} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", message: reason)
    end
  end

  def create_billing_session(conn, _params, %User{stripe_customer_id: customer_id}) do
    case Kritikos.Stripe.create_billing_session(customer_id) do
      {:ok, billing_portal_session} ->
        conn
        |> render("stripe_object.json", stripe_object: billing_portal_session)

      {:error, reason} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", message: reason)
    end
  end

  defp ensure_stripe_customer(
         %{assigns: %{user: %User{stripe_customer_id: nil} = user}} = conn,
         _plug_params
       ) do
    case Kritikos.Stripe.create_customer(user) do
      {:ok, %Stripe.Customer{id: id}} ->
        updated_user = Map.put(user, :stripe_customer_id, id)

        Plug.Conn.assign(conn, :user, updated_user)

      {:error, reason} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.json", message: reason)
        |> halt
    end
  end

  defp ensure_stripe_customer(conn, _plug_params), do: conn
end
