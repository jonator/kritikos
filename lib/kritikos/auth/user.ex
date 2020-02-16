defmodule Kritikos.Auth.User do
  @moduledoc """
  Represents a user
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.Session

  schema "users" do
    field :email, :string, unique: true
    field :first_last_name, :string
    field :is_active, :boolean, default: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_many :sessions, Session

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :first_last_name])
    |> validate_required([:email, :password, :password_confirmation, :first_last_name])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_required([:first_last_name])
    |> validate_format(:first_last_name, ~r/\ /, message: "must contain a space between names")
    |> validate_length(:first_last_name, max: 35)
    |> capitalize_first_last_name
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash
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

  defp put_password_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password, password_confirmation: _}
         } = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
