defmodule KritikosWeb.LayoutView do
  use KritikosWeb, :view

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end
end
