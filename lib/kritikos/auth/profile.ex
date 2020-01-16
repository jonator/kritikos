defmodule Kritikos.Auth.Profile do
  @moduledoc """
  Contains user information that is app-specific
  """
  use Ecto.Schema
  import Ecto.Changeset
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
  def create_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :substitute_session_keyword])
    |> validate_required([:name])
    |> capitalize_name
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
