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
    field :name, :string
    field :substitute_session_keyword, :string
    field :redirect_count, :integer, default: 0
    has_many :sessions, Session

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :name, :substitute_session_keyword])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
    |> capitalize_name
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

  defp capitalize_name(%Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset) do
    capital_name =
      String.split(name)
      |> Enum.map(&String.capitalize(&1))
      |> Enum.intersperse(" ")
      |> Enum.reduce("", fn el, acc -> acc <> el end)

    change(changeset, %{name: capital_name})
  end

  defp capitalize_name(changeset), do: changeset
end
