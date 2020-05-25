defmodule KritikosWeb.PromptView do
  use KritikosWeb, :view
  alias Kritikos.Votes.{Vote, Feedback}

  def render("vote.json", %{vote: %Vote{id: vid, vote_datetime: vdt, vote_level_id: tl_id}}) do
    %{vote: %{id: vid, voteDateTime: vdt, voteLevelId: tl_id}}
  end

  def render("faux_vote.json", %{vote_level_id: vote_level_id}) do
    %{vote: %{voteLevelId: vote_level_id}}
  end

  def render("feedback.json", %{feedback: %Feedback{id: fid}}) do
    %{feedback: %{id: fid}}
  end

  def render("session_owner.json", %{message: msg}) do
    %{message: msg}
  end
end
