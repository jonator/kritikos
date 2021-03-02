defmodule Kritikos.Votes.VoteLevel do
  @moduledoc """
  Defines various categories of a user vote.
  """
  use Ecto.Schema

  schema "vote_levels" do
    field :description, :string
  end
end
