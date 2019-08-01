defmodule KritikosWeb.SessionView do
  use KritikosWeb, :view
  alias KritikosWeb.UserView

  @doc "forwards view calls from session controller to user views"
  def render(template, assigns) do
    UserView.render(template, assigns)
  end
end
