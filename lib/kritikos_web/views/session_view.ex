defmodule KritikosWeb.SessionView do
  use KritikosWeb, :view
  alias KritikosWeb.UserView

  def render("logged_out.json", %{success: true}) do
    %{logged_out: true}
  end

  def render("logged_out.json", %{success: false}) do
    %{logged_out: false, errors: ["log out failed"]}
  end

  @doc "forwards view calls from session controller to user views"
  def render("login.json", assigns) do
    UserView.render("login.json", assigns)
  end
end
