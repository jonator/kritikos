defmodule Kritikos.Votes.Queries do
  @moduledoc """
  Composes Kritikos Vote queries
  """
  import Ecto.Query
  alias Kritikos.Votes.Vote

  def all_with_ids(vote_ids) do
    from(v in Vote, where: v.id in ^vote_ids, select: v.id)
  end

  def votes_in_time_range(query \\ Vote, start_datetime, end_datetime) do
    query
    |> where([v], v.vote_datetime >= ^start_datetime)
    |> where([v], v.vote_datetime <= ^end_datetime)
  end

  def viewed_votes(query \\ Vote, is_viewed?) do
    query |> where([v], v.viewed == ^is_viewed?)
  end
end
