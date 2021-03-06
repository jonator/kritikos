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
    field :is_email_active, :boolean, default: false
    field :stripe_customer_id, :string, default: nil
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_many :sessions, Session

    timestamps()
  end

  def create_changeset(user, attrs),
    do:
      user
      |> cast(attrs, [:email, :password, :password_confirmation, :first_last_name])
      |> validate_required([:email, :password, :password_confirmation, :first_last_name])
      |> unique_constraint(:email)
      |> validate_format(:email, ~r/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/)
      |> validate_required([:first_last_name])
      |> validate_format(:first_last_name, ~r/\ /, message: "must contain a space between names")
      |> validate_length(:first_last_name, max: 35)
      |> capitalize_first_last_name
      |> validate_password_confirmation
      |> put_password_hash

  def changeset(user, attrs),
    do:
      user
      |> cast(attrs, [:password, :password_confirmation, :is_email_active, :stripe_customer_id])
      |> validate_password_confirmation
      |> put_password_hash

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

  defp validate_password_confirmation(changeset),
    do: validate_confirmation(changeset, :password, message: "does not match password")

  defp put_password_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password, password_confirmation: _}
         } = changeset
       ),
       do: change(changeset, Bcrypt.add_hash(password))

  defp put_password_hash(changeset), do: changeset
end
