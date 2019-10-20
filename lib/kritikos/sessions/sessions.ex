defmodule Kritikos.Sessions do
  import Ecto.Query, warn: false
  import Kritikos.Repo
  alias Kritikos.Sessions.{LiveSession, KeywordFactory, ResolvedSession}
  alias Kritikos.Votes.{ResolvedVote, ResolvedTextual, VoteLevel}

  def start(host_id) do
    keyword = KeywordFactory.next_available()
    LiveSession.start_link(%LiveSession{host_id: host_id, keyword: keyword})
  end

  def summaries_for_user(user_id) do
    Enum.map(all(from rs in ResolvedSession, where: rs.host_id == ^user_id), fn session ->
      res_votes_verdict =
        get_resolved_votes_for_session(session.id)
        |> resolved_votes_verdict()

      text_resp_votes_count =
        get_resolved_texts_for_session(session.id)
        |> Enum.count()
    end)
  end

  def fetch_previous_session_overview(keyword, user_id) do
    with %ResolvedSession{} = res_session <-
           one(
             from rs in ResolvedSession, where: rs.host_id == ^user_id and rs.keyword == ^keyword
           ),
         [%ResolvedVote{} | _] = res_votes <- get_resolved_votes_for_session(res_session.id),
         [%ResolvedTextual{} | _] = res_text_votes <-
           get_resolved_texts_for_session(res_session.id) do
      {:ok, res_session, res_votes, res_text_votes}
    else
      _ ->
        {:error, "Problems fetching previous session"}
    end
  end

  defp get_resolved_votes_for_session(session_id) do
    all(from rv in ResolvedVote, where: rv.session_id == ^session_id)
  end

  defp get_resolved_texts_for_session(session_id) do
    all(
      from rv in ResolvedVote,
        join: rtv in ResolvedTextual,
        on: rv.id == rtv.vote_id and rv.session_id == ^session_id,
        select: rtv
    )
  end

  defp resolved_votes_verdict(res_votes) do
    available_levels = all(VoteLevel) |> Map.new(fn vl -> {vl.id, vl} end)

    # Enum.reduce(res_votes, available_levels, fn rv ->
    #   nil
    # end)
  end
end
