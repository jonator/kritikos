defmodule KritikosWeb.SessionsView do
  use KritikosWeb, :view
  alias KritikosWeb.FormatHelpers

  def render("show.json", %{session: session}) do
    %{session: render_one(session, __MODULE__, "session.json")}
  end

  def render("session.json", %{sessions: session}) do
    FormatHelpers.format_map_with_keys(session, [
      :id,
      :keyword,
      :prompt_question,
      :start_datetime,
      :tags,
      :votes
    ])
  end
end
