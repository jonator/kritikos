defmodule Kritikos.Auth.Profile do
  @moduledoc """
  Contains user information that is app-specific
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions
  alias Kritikos.Sessions.Session
  alias Kritikos.Auth
  alias Kritikos.Auth.User

  schema "user_profiles" do
    belongs_to :user, User
    field :first_last_name, :string
    field :substitute_session_keyword, :string
    field :redirect_count, :integer, default: 0
    has_many :sessions, Session

    timestamps()
  end

  @doc false
  def create_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:first_last_name])
    |> validate_required([:first_last_name])
    |> validate_format(:first_last_name, ~r/\ /, message: "must contain a space between names")
    |> validate_length(:first_last_name, max: 35)
    |> capitalize_first_last_name
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:substitute_session_keyword, :redirect_count])
    |> validate_substitute_session_keyword
  end

  defp capitalize_first_last_name(
         %Ecto.Changeset{valid?: true, changes: %{first_last_name: name}} = changeset
       ) do
    capital_name =
      String.split(name)
      |> Enum.map(&String.capitalize(&1))
      |> Enum.intersperse(" ")
      |> Enum.reduce("", fn el, acc -> acc <> el end)

    change(changeset, %{first_last_name: capital_name})
  end

  defp capitalize_first_last_name(changeset), do: changeset

  defp validate_substitute_session_keyword(
         %Ecto.Changeset{valid?: true, changes: %{substitute_session_keyword: ssk}} = changeset
       ) do
    profile_id = fetch_field(changeset, :id)
    user_id = Auth.get_profile(profile_id, preload: :user)[:user][:id]
    open_sessions = Sessions.get_all_open_for_user(user_id)

    if Enum.any?(open_sessions, fn s -> s.keyword == ssk end) do
      add_error(changeset, :substitute_session_keyword, "does not correspond to an open session")
    else
      changeset
    end
  end

  defp validate_substitute_session_keyword(changeset), do: changeset
end
