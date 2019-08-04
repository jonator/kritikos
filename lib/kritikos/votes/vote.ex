defmodule Kritikos.Votes.Vote do
  @enforce_keys [:session_id, :vote_level_id, :vote_datetime]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          session_id: integer(),
          vote_level_id: integer(),
          vote_datetime: DateTime.t()
        }
end
