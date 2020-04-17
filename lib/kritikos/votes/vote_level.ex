defmodule Kritikos.Votes.VoteLevel do
  use Ecto.Schema

  schema "vote_levels" do
    field :description, :string
  end
end
