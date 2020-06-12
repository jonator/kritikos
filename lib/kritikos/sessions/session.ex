defmodule Kritikos.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Auth.User
  alias Kritikos.Sessions.Tag
  alias Kritikos.Votes.Vote

  schema "sessions" do
    field :keyword, :string
    field :name, :string
    field :prompt_question, :string
    field :start_datetime, :utc_datetime
    field :end_datetime, :utc_datetime
    field :is_active, :boolean, default: true
    belongs_to :user, User
    has_many :votes, Vote
    has_many :tags, Tag
  end

  @doc false
  def create_changeset(session, attrs \\ %{}) do
    now = %{DateTime.utc_now() | microsecond: {0, 0}}

    session
    |> cast(attrs, [:keyword, :name, :prompt_question, :user_id])
    |> cast_assoc(:tags, with: &Tag.create_changeset/2)
    |> validate_required([:keyword, :user_id])
    |> assoc_constraint(:user)
    |> validate_length(:keyword, min: 3, max: 30)
    |> validate_format(:keyword, ~r/^[A-Za-z0-9_-]*$/,
      message: "invalid format (must only contain A-Z, a-z, 0-9, _, and no spaces)"
    )
    |> keyword_unique
    |> validate_length(:name, min: 3, max: 30)
    |> put_change(:start_datetime, now)
    |> validate_length(:prompt_question, max: 50)
  end

  def changeset(session, attrs \\ %{}) do
    session
    |> cast(attrs, [:end_datetime, :is_active])
    |> validate_end_datetime
  end

  defp keyword_unique(%Ecto.Changeset{valid?: true, changes: %{keyword: kw}} = changeset) do
    if Kritikos.Sessions.get_all_open()
       |> Enum.any?(fn session -> session.keyword == kw end) do
      add_error(changeset, :keyword, "already taken")
    else
      changeset
    end
  end

  defp keyword_unique(changeset), do: changeset

  defp validate_end_datetime(changeset) do
    start_datetime = get_field(changeset, :start_datetime)

    validate_change(changeset, :end_datetime, fn :end_datetime, end_datetime ->
      comparison = DateTime.compare(start_datetime, end_datetime)
      has_microseconds? = end_datetime.microsecond != {0, 0}

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
