defmodule Kritikos.Sessions.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.Session

  @derive {Jason.Encoder, only: [:text]}

  schema "session_tags" do
    field :text, :string
    belongs_to :session, Session

    timestamps()
  end

  @doc false
  def create_changeset(tags, attrs) do
    tags
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, max: 15)
  end
end
