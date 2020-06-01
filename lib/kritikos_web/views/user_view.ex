defmodule KritikosWeb.UserView do
  use KritikosWeb, :view
  alias KritikosWeb.FormatHelpers

  def render("show.json", %{user: user}) do
    %{user: render_one(user, __MODULE__, "user.json")}
  end

  def render("login.json", %{user: user}) do
    %{user: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user
    |> Map.from_struct()
    |> Map.put(:inserted_at, NaiveDateTime.to_iso8601(user.inserted_at))
    |> Map.put(:updated_at, NaiveDateTime.to_iso8601(user.updated_at))
    |> Map.take([:id, :email])
    |> FormatHelpers.camelize()
  end

  def render("verification_email_sent.json", %{sent: true}) do
    %{success: true}
  end

  def render("verification_email_sent.json", %{sent: false}) do
    %{success: false, errors: ["Could not send verification email. Internal error."]}
  end
end
