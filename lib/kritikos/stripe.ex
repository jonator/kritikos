defmodule Kritikos.Stripe do
  alias Kritikos.{Auth, Auth.User}
  require Logger

  def create_customer(%User{email: email, is_email_active: true} = user) do
    case Stripe.Customer.create(%{email: email, name: user.first_last_name}) do
      {:ok, stripe_customer} ->
        case Auth.create_customer(user, stripe_customer.id) do
          {:ok, %User{}} ->
            {:ok, stripe_customer}

          {:error, _reason} = e ->
            e
        end

      error ->
        stripe_error(error)
    end
  end

  def create_customer(%User{is_email_active: false}) do
    {:error, "email must be verified"}
  end

  def create_checkout_session(customer_id) do
    host = config_host()
    success_url = host <> "/dashboard?subscription=pro"
    cancel_url = host <> "/dashboard?subscription=cancelled"
    %Stripe.Plan{id: plan_id} = get_pro_plan()

    case Stripe.Session.create(%{
           customer: customer_id,
           cancel_url: cancel_url,
           success_url: success_url,
           payment_method_types: ["card"],
           subscription_data: %{
             items: [%{plan: plan_id}]
           }
         }) do
      {:error, _reason} = e ->
        stripe_error(e)

      ok ->
        ok
    end
  end

  def create_billing_session(customer_id) do
    host = config_host()

    case Stripe.BillingPortal.Session.create(%{
           customer: customer_id,
           return_url: host <> "/dashboard#/settings"
         }) do
      {:error, _reason} = e ->
        stripe_error(e)

      ok ->
        ok
    end
  end

  def get_user_subscription_status(nil), do: "free"

  def get_user_subscription_status(customer_id) do
    pro_plan_id = get_pro_plan().id

    case Stripe.Customer.retrieve(customer_id) do
      {:ok,
       %Stripe.Customer{
         subscriptions: %Stripe.List{
           data: sub_list
         }
       }} ->
        if Enum.any?(sub_list, fn sub ->
             sub.plan.id == pro_plan_id and sub.status == "active"
           end) do
          "pro"
        else
          "free"
        end

      {:error, _reason} = e ->
        _ = stripe_error(e)
        "free"
    end
  end

  defp get_pro_plan() do
    %Stripe.Product{id: id} = get_pro_product()
    {:ok, %Stripe.List{data: plans}} = Stripe.Plan.list()

    Enum.find(plans, fn %Stripe.Plan{product: product_id} -> id == product_id end)
  end

  defp get_pro_product do
    {:ok, %Stripe.List{data: products}} = Stripe.Product.list()

    Enum.find(products, fn %Stripe.Product{name: name} -> name == "Professional" end)
  end

  defp stripe_error({:error, %Stripe.Error{user_message: nil} = e}) do
    inspect(e) |> Logger.error()

    {:error, e.message}
  end

  defp stripe_error({:error, %Stripe.Error{user_message: msg} = e}) do
    inspect(e) |> Logger.error()

    {:error, msg}
  end

  defp config_host, do: Application.fetch_env!(:kritikos, KritikosWeb.Endpoint)[:url][:host]
end
