defmodule Kritikos.Sessions.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.Session

  schema "session_tags" do
    field :text, :string
    belongs_to :session, Session

    timestamps()
  end

  @doc false
  def changeset(tags, attrs) do
    tags
    |> cast(attrs, [:text, :session_id])
    |> validate_required([:text])
    |> foreign_key_constraint(:session_id)
  end
end
