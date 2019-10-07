defmodule Kritikos.Votes.Text do
  @enforce_keys [:session_keyword, :text, :voter_number]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          session_keyword: String.t(),
          text: String.t(),
          voter_number: integer()
        }
end
