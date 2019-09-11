defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Kritikos.Repo
  alias Comeonin.Bcrypt
  alias Kritikos.Auth.{User, Token}

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def authenticate_user(email, plain_text_password) do
    case check_password(email, plain_text_password) do
      {:ok, user} = valid_result ->
        create_token(user)

        valid_result

      {:error, _msg} ->
        {:error, "Invalid username or password"}
    end
  end

  def unauthenticate_user(conn) do
    IO.inspect(conn.cookies)
  end

  def register_user(attrs \\ %{}) do
    case %User{} |> User.changeset(attrs) |> Repo.insert() do
      {:ok, user} = valid_result ->
        create_token(user)

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
    Repo.get_by!(User, email: email)
    |> Bcrypt.check_pass(plain_text_password)
  end

  defp create_token(user) do
    token = Token.sign(user.id)

    Ecto.build_assoc(user, :auth_tokens)
    |> Token.changeset(%{token: token})
    |> Repo.insert()
  end
end
