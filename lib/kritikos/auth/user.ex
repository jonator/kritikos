defmodule Kritikos.Auth.User do
  @moduledoc """
  Represents a user
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Auth.Profile

  schema "users" do
    field :email, :string, unique: true
    field :is_active, :boolean, default: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_one :profile, Profile

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash
  end

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
