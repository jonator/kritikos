defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Kritikos.Repo
  alias Kritikos.Auth.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def authenticate_user(email, plain_text_password) do
    if String.length(email) == 0 || String.length(plain_text_password) == 0 do
      {:error, %{credentials: ["invalid"]}}
    else
      case check_password(email, plain_text_password) do
        {:ok, _user} = valid_result ->
          valid_result

        _ ->
          {:error, %{credentials: ["invalid"]}}
      end
    end
  end

  def unauthenticate_user(conn) do
    IO.inspect(conn.cookies)
  end

  def register_user(attrs \\ %{}) do
    case %User{} |> User.create_changeset(attrs) |> Repo.insert() do
      {:ok, _user} = valid_result ->
        valid_result

      {:error, _changeset} = error_result ->
        error_result
    end
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

  defp check_password(email, plain_text_password) do
    Repo.get_by(User, email: email)
    |> Bcrypt.check_pass(plain_text_password)
  end
end
