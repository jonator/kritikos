defmodule Kritikos.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string, unique: true
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash
    |> activate_user
  end

  defp put_password_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password, password_confirmation: password_confirmation}
         } = changeset
       )
       when not is_nil(password_confirmation) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset

  defp activate_user(changeset) do
    change(changeset, is_active: true)
  end
end
