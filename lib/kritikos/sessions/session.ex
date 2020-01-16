defmodule Kritikos.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Auth.Profile
  alias Kritikos.Sessions.Tag
  alias Kritikos.Votes.Vote

  @derive {Jason.Encoder,
           only: [:id, :keyword, :prompt_question, :start_datetime, :end_datetime, :votes, :tags]}

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
  def create_changeset(session, attrs \\ %{}) do
    now = %{DateTime.utc_now() | microsecond: {0, 0}}

    session
    |> cast(attrs, [:keyword, :prompt_question, :end_datetime, :profile_id])
    |> cast_assoc(:tags, with: &Tag.create_changeset/2)
    |> validate_required([:keyword, :profile_id])
    |> assoc_constraint(:profile)
    |> keyword_valid
    |> put_change(:start_datetime, now)
    |> validate_end_datetime
    |> validate_length(:prompt_question, max: 30)
  end

  def changeset(session, attrs \\ %{}) do
    session
    |> cast(attrs, [:end_datetime])
    |> validate_end_datetime
  end

  defp keyword_valid(%Ecto.Changeset{valid?: true, changes: %{keyword: kw}} = changeset) do
    if Kritikos.Sessions.get_all_open()
       |> Enum.any?(fn session -> session.keyword == kw end) do
      add_error(changeset, :keyword, "already taken")
    else
      changeset
    end
  end

  defp keyword_valid(changeset), do: changeset

  defp validate_end_datetime(changeset) do
    start_datetime = get_change(changeset, :start_datetime)

    validate_change(changeset, :end_datetime, fn :end_datetime, end_datetime ->
      comparison = DateTime.compare(start_datetime, end_datetime)
      has_microseconds? = end_datetime.microseconds != {0, 0}

      if comparison == :gt || comparison == :eq do
        return = [end_datetime: "must be after start date/time"]

        if has_microseconds? do
          return ++ [end_datetime: "must not have microseconds"]
        else
          return
        end
      else
        []
      end
    end)
  end
end
