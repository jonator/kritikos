defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """
  @token_salt Application.get_env(:kritikos, KritikosWeb.Endpoint)[:secret_key_base]
  alias Kritikos.Repo
  alias Kritikos.Helpers
  alias __MODULE__.{User, Queries}

  def sign_user_token(user_id) do
    Phoenix.Token.sign(KritikosWeb.Endpoint, @token_salt, user_id)
  end

  def user_from_token(token) do
    case Phoenix.Token.verify(KritikosWeb.Endpoint, @token_salt, token, max_age: 86_400) do
      {:ok, user_id} ->
        {:ok, get_user(user_id)}

      {:error, _reason} = err ->
        err
    end
  end

  def get_user(user_id, opts \\ [])
  def get_user(user_id, opts), do: Helpers.get_schema(User, user_id, opts)

  def get_active_user(user_id) do
    Repo.one(Queries.active_user(user_id))
  end

  def authenticate_user(email, plain_text_password) do
    err_msg = "Credentials invalid"

    if String.length(email) == 0 || String.length(plain_text_password) == 0 do
      {:error, [err_msg]}
    else
      case check_password(email, plain_text_password) do
        {:ok, _user} = valid_result ->
          valid_result

        _ ->
          {:error, [err_msg]}
      end
    end
  end

  def register_user(attrs \\ %{}) do
    case User.create_changeset(%User{}, attrs) |> Repo.insert() do
      {:ok, _user} = user_valid ->
        user_valid

      {:error, _changeset} = error_result ->
        error_result
    end
  end

  defp check_password(email, plain_text_password) do
    Repo.get_by(User, email: email)
    |> Bcrypt.check_pass(plain_text_password)
  end
end
