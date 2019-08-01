defmodule Kritikos.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string, unique: true
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> hash_password
    |> activate_user
  end

  @doc false
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: p}} = cs) do
    pw_hash = Bcrypt.hashpwsalt(p)
    change(cs, password_hash: pw_hash)
  end

  defp hash_password(changeset) do
    changeset
  end

  defp activate_user(changeset) do
    change(changeset, is_active: true)
  end
end
