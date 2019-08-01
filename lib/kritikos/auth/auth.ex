defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Kritikos.Repo
  alias Comeonin.Bcrypt
  alias Kritikos.Auth.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def authenticate_user(email, plain_text_password) do
    query = from u in User, where: u.email == ^email

    Repo.one(query)
    |> check_password(plain_text_password)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}

  defp check_password(user, plain_text_password) do
    if Bcrypt.checkpw(plain_text_password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Incorrect email or password"}
    end
  end
end
