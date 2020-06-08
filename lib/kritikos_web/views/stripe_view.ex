defmodule KritikosWeb.StripeView do
  use KritikosWeb, :view
  import KritikosWeb.FormatHelpers

  def render("stripe_object.json", %{stripe_object: stripe_object}) do
    %{stripe_object: format_map_with_keys(stripe_object)}
  end
end
