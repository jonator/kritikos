defmodule Kritikos.Votes.Text do
  @enforce_keys [:text, :voter_number]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          text: String.t(),
          voter_number: integer()
        }
end
