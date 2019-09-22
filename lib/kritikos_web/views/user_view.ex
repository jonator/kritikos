defmodule KritikosWeb.UserView do
  use KritikosWeb, :view
  alias KritikosWeb.{UserView, FormatHelpers}

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("login.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json"), redirect: "/dashboard"}
  end

  def render("user.json", %{user: user}) do
    user
    |> Map.from_struct()
    |> Map.put(:inserted_at, NaiveDateTime.to_iso8601(user.inserted_at))
    |> Map.put(:updated_at, NaiveDateTime.to_iso8601(user.updated_at))
    |> Map.take([:id, :email])
    |> FormatHelpers.camelize()
  end
end
