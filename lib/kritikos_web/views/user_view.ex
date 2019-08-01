defmodule KritikosWeb.UserView do
  use KritikosWeb, :view
  alias KritikosWeb.{UserView, FormatHelpers}

  def render("show.json", %{jwt: jwt, user: user}) do
    %{user: Map.merge(render_one(user, UserView, "user.json"), %{token: jwt})}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("login.json", %{jwt: jwt, user: user}) do
    %{user: Map.merge(render_one(user, UserView, "user.json"), %{token: jwt})}
  end

  def render("user.json", %{user: user}) do
    user
    |> Map.from_struct()
    |> Map.put(:inserted_at, NaiveDateTime.to_iso8601(user.inserted_at))
    |> Map.put(:updated_at, NaiveDateTime.to_iso8601(user.updated_at))
    |> Map.take([:id, :email])
    |> FormatHelpers.camelize()
  end

  def render("error.json", %{message: msg}), do: %{error: msg}
end
