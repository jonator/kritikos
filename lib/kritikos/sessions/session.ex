defmodule Kritikos.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Auth.Profile
  alias Kritikos.Sessions.Tag
  alias Kritikos.Votes.Vote

  schema "sessions" do
    field :keyword, :string
    field :prompt_question, :string
    field :start_datetime, :utc_datetime
    field :end_datetime, :utc_datetime
    belongs_to :profile, Profile
    has_many :votes, Vote
    has_many :tags, Tag
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:keyword, :prompt_question, :start_datetime, :end_datetime, :profile_id])
    |> validate_required([:keyword, :start_datetime, :profile_id])
    |> unique_constraint(:keyword)
    |> validate_length(:prompt_question, max: 20)
    |> foreign_key_constraint(:profile_id)
  end
end
