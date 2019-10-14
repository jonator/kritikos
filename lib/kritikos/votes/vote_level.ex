defmodule Kritikos.Votes.VoteLevel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vote_levels" do
    field :description, :string
  end
end
