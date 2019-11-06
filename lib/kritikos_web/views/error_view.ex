defmodule KritikosWeb.ErrorView do
  use KritikosWeb, :view

  def render("error.json", assigns) do
    %{errors: assigns[:message]}
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
