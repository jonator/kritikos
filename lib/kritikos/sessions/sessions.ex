defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  import Ecto.Query, warn: false
  import Kritikos.Repo
  alias Kritikos.Sessions.{LiveSession, KeywordFactory, ResolvedSession}
  alias Kritikos.Votes.{ResolvedVote, ResolvedTextual, VoteLevel}

  def start(host_id) do
    keyword = KeywordFactory.next_available_for_user(host_id)
    LiveSession.start_link(%LiveSession{host_id: host_id, keyword: keyword})
  end

  def sessions_for_user(user_id) do
    all(from rs in ResolvedSession, where: rs.host_id == ^user_id)
  end

  def summaries_for_user(user_id) do
    Enum.map(sessions_for_user(user_id), fn session ->
      res_overall_feedback_id =
        get_resolved_votes_for_session(session.id)
        |> resolved_overall_feedback_id()

      overall_feedback_desc =
        case res_overall_feedback_id do
          id when is_integer(id) ->
            one(
              from vl in VoteLevel,
                where: vl.id == ^res_overall_feedback_id,
                select: vl.description
            )

          :empty ->
            :empty
        end

      text_resp_votes_count =
        get_resolved_texts_for_session(session.id)
        |> Enum.count()

      %{
        session: session,
        texts_count: text_resp_votes_count,
        overall_feedback: overall_feedback_desc
      }
    end)
    |> Enum.sort(&(DateTime.compare(&1.session.end_datetime, &2.session.end_datetime) == :gt))
  end

  def previous_overview(keyword, user_id) do
    with %ResolvedSession{} = res_session <-
           one(
             from rs in ResolvedSession, where: rs.host_id == ^user_id and rs.keyword == ^keyword
           ),
         [%ResolvedVote{} | _] = res_votes <- get_resolved_votes_for_session(res_session.id),
         [%ResolvedTextual{} | _] = res_text_votes <-
           get_resolved_texts_for_session(res_session.id) do
      {:ok, res_session, res_votes, res_text_votes}
    else
      nil ->
        {:error, "Keyword doesn't have a closed session"}

      [] ->
        {:error, "No votes for this session"}

      _ ->
        {:error, "Problems opening session information"}
    end
  end

  def all_overview(user_id) do
    user_votes = resolved_votes_for_user(user_id)

    overall_feedback =
      user_votes
      |> resolved_overall_feedback_id()

    session_count = sessions_for_user(user_id) |> Enum.count()

    %{
      session_count: session_count,
      overall_feedback: overall_feedback,
      vote_count: Enum.count(user_votes)
    }
  end

  defp get_resolved_votes_for_session(session_id) do
    all(from rv in ResolvedVote, where: rv.session_id == ^session_id)
  end

  defp get_resolved_texts_for_session(session_id) do
    all(
      from rv in ResolvedVote,
        join: rtv in ResolvedTextual,
        on: rv.id == rtv.vote_id and rv.session_id == ^session_id,
        select: rtv,
        order_by: [desc: rv.vote_level_id]
    )
  end

  defp resolved_overall_feedback_id([_ | _] = res_votes) do
    Enum.reduce(res_votes, %{}, fn rv, acc ->
      Map.update(acc, rv.vote_level_id, 1, &(&1 + 1))
    end)
    |> Enum.max()
    |> elem(0)
  end

  defp resolved_overall_feedback_id([]), do: :empty

  defp resolved_votes_for_user(user_id) do
    all(
      from rv in ResolvedVote,
        join: rs in ResolvedSession,
        on: rs.id == rv.session_id and rs.host_id == ^user_id
    )
  end
end
