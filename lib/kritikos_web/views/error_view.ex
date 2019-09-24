defmodule KritikosWeb.ErrorView do
  use KritikosWeb, :view

  def render("error.json", assigns) do
    %{errors: assigns[:message]}
  end
end
