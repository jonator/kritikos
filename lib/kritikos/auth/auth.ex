defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """
  alias Kritikos.Repo
  alias __MODULE__.{User, Profile, Queries}

  def get_user(user_id), do: Repo.get(User, user_id)

  def get_user_record(user_id) do
    Queries.user_record(user_id)
    |> Repo.one()
  end

  def get_user_assocs(user_id, assocs) do
    Queries.user_assocs(user_id, assocs)
    |> Repo.all()
  end

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

  def register_user(attrs \\ %{}) do
    case %User{} |> User.create_changeset(attrs) |> Repo.insert() do
      {:ok, user} = user_valid ->
        {profile_operation, p_or_changeset} =
          Ecto.build_assoc(user, :profile)
          |> Profile.changeset(attrs)
          |> Repo.insert()

        if profile_operation == :ok do
          user_valid
        else
          {:error, p_or_changeset}
        end

      {:error, _changeset} = error_result ->
        error_result
    end
  end

  defp check_password(email, plain_text_password) do
    Repo.get_by(User, email: email)
    |> Bcrypt.check_pass(plain_text_password)
  end
end
