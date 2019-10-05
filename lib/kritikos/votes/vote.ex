defmodule Kritikos.Votes.Vote do
  @enforce_keys [:session_keyword, :vote_level_id, :vote_datetime]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          session_keyword: String.t(),
          vote_level_id: integer(),
          vote_datetime: DateTime.t()
        }
end
