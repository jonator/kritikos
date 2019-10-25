defmodule Kritikos.Votes do
  import Ecto.Query
  import Kritikos.Repo
  alias __MODULE__.VoteLevel

  def vote_levels_descriptions do
    all(from(v in VoteLevel, select: {v.id, v.description})) |> Map.new()
  end
end
