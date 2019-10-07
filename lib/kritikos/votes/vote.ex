defmodule Kritikos.Votes.Vote do
  @enforce_keys [:session_keyword, :vote_level_id, :vote_datetime]
  defstruct [:session_keyword, :vote_level_id, :vote_datetime, :voter_number]

  @type t() :: %__MODULE__{
          session_keyword: String.t(),
          vote_level_id: integer(),
          vote_datetime: DateTime.t(),
          voter_number: integer()
        }
end
