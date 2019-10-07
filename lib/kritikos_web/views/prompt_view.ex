defmodule KritikosWeb.PromptView do
  use KritikosWeb, :view

  def render("redirect.json", params) do
    %{
      redirect: params[:redirect]
    }
  end
end
