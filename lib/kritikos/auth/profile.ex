defmodule Kritikos.Auth.Profile do
  @moduledoc """
  Contains user information that is app-specific
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Repo
  alias Kritikos.Sessions.Session
  alias Kritikos.Auth.User

  schema "user_profiles" do
    belongs_to :user, User
    field :substitute_session_keyword, :string
    field :redirect_count, :integer, default: 0
    has_many :sessions, Session

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :substitute_session_keyword])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end

  def get_or_create_for_user(user_id) do
    case Repo.get(User, user_id) |> Ecto.assoc(__MODULE__) |> Repo.one() do
      %{} ->
        changeset(%__MODULE__{}, %{user_id: user_id})
        |> Repo.insert()

      profile ->
        profile
    end
  end
end
