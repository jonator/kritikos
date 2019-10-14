defmodule Kritikos.Votes.Vote do
  @enforce_keys [:vote_level_id, :vote_datetime]
  defstruct [:vote_level_id, :vote_datetime, :voter_number]

  @type t() :: %__MODULE__{
          vote_level_id: integer(),
          vote_datetime: DateTime.t(),
          voter_number: integer()
        }
end
