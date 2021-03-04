defmodule Kritikos.Votes.Queries do
  @moduledoc """
  Composes Kritikos Vote queries
  """
  import Ecto.Query
  alias Kritikos.Votes.Vote

  def all_with_ids(vote_ids) do
    from(v in Vote, where: v.id in ^vote_ids, select: v.id)
  end
end
